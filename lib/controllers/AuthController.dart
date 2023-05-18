import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/controllers/TimeslotController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/env.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:restart/models/auth/UserModel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/App.dart';
import 'package:restart/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:restart/controllers/UserController.dart';

enum AuthState { LOGGEDIN, LOGGEDOUT, UNKNOWN }

enum SignedInWith { GOOGLE, APPLE, FB }

class AuthController extends GetxController {
  final box = GetStorage();
  Rx<AuthState> state = AuthState.UNKNOWN.obs;
  late User? googleUser;
  Rxn<UserModel> user = Rxn<UserModel>();
  RxnString tk = RxnString(null);
  Rx<int> selectedIndex = 0.obs;
  RxnBool showHomeTutorial = RxnBool(null);
  Rxn<SignedInWith> signInWith = Rxn();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  onInit() async {
    print("authorising user");
    super.onInit();
    tk.value = box.read('tk');
    showHomeTutorial.value = box.read("showHomeTutorial");
    // box.write("showTutorial", null);
    print("showTutorial: " + showHomeTutorial.value.toString());

    print("tk: " + tk.value.toString());
    if (tk.value == null) {
      state.value = AuthState.LOGGEDOUT;
    } else {
      //verifying token
      print("verifying token, $API_URL/auth/verify/token=$tk");
      var response =
          await http.post(Uri.parse('$API_URL/auth/verify/token=$tk'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        String uid = jsonDecode(response.body)["message"]["uid"];
        var response2 = await http.get(
          Uri.parse('$API_URL/users/$uid'),
          headers: {
            'Authorization': 'Bearer $tk',
          },
        ); // no authorization yet
        user.value = UserModel.fromJson(jsonDecode(response2.body));
        String fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
        Get.lazyPut(() => UserController());
        if (!(fcmToken == user.value!.fcmToken)) {
          print('getting fcm token');
          await Get.find<UserController>().updateFcmToken(fcmToken);
        }
        FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
          await Get.find<UserController>().updateFcmToken(fcmToken);
        }).onError((err) {
          // Error getting token.
          print("ERROR GETTING TOKEN");
        });
        print('fcm tk: ' + fcmToken.toString());
        state.value = AuthState.LOGGEDIN;
        Get.to(App());
      } else {
        state.value = AuthState.LOGGEDOUT;
        box.remove('tk');
      }
    }
  }

  Future<void> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print(credential);
      var body = {
        "name": (credential.givenName ?? "") + (credential.familyName ?? ""),
        "email": credential.email,
        "hp": ' ',
        "profilePic": ' ',
        "isSeller": true.toString(),
      };
      signInWith.value = SignedInWith.APPLE;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      print("GOOGLE SIGN IN " + googleSignInAccount.toString());
      if (googleSignInAccount == null) {
        throw Exception("Can't login!");
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      var body = {
        "name": googleSignInAccount.displayName ?? ' ',
        "email": googleSignInAccount.email,
        "hp": ' ',
        "profilePic": googleSignInAccount.photoUrl ?? ' ',
        "isSeller": true.toString(),
      };
      state.value = AuthState.UNKNOWN;
      var response =
          await http.post(Uri.parse('$API_URL/auth/signup'), body: body);
      print("server response " + response.statusCode.toString());
      if (response.statusCode > 200 && response.statusCode < 300) {
        var body = jsonDecode(response.body);
        tk.value = body['token'];
        box.write('tk', tk.value);
        user.value = UserModel.fromJson(body['user']);
        state.value = AuthState.LOGGEDIN;
        signInWith.value = SignedInWith.GOOGLE;
      } else {
        //DISPLAY ERROR
        print("BACKEND AUTH ERROR");
        state.value = AuthState.LOGGEDOUT;
        return;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithFacebook() async {}

  Future<void> signOut() async {
    if (signInWith.value == SignedInWith.GOOGLE) {
      print("signing out from google");
      await _googleSignIn.signOut();
    }

    Get.delete<UserController>();
    Get.delete<TimeslotController>();
    Get.delete<TxnController>();
    var response = await http.post(Uri.parse('$API_URL/auth/logout/token=$tk'));
    box.remove('tk');
    signInWith.value = SignedInWith.FB;
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Logged out!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.offAll(const LoginScreen());
      state.value = AuthState.LOGGEDOUT;
    } else {
      Fluttertoast.showToast(
          msg: "Unable to logout. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
