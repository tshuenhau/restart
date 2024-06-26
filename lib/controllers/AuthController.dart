import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/env.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:restart/models/auth/UserModel.dart';
import 'package:restart/screens/EmailVerificationScreen.dart';
import 'package:restart/screens/LoginScreen.dart';
import 'package:restart/screens/SetDetailsScreen.dart';

import 'MissionController.dart';

enum AuthState { LOGGEDIN, LOGGEDOUT, UNKNOWN }

enum SignedInWith { GOOGLE, APPLE, EMAIL }

class AuthController extends GetxController {
  final box = GetStorage();
  Rx<AuthState> state = AuthState.UNKNOWN.obs;
  late User? googleUser;
  Rxn<UserModel> user = Rxn<UserModel>();
  RxnString tk = RxnString(null);
  // Rx<int> selectedIndex = 0.obs;
  RxnBool showHomeTutorial = RxnBool(null);
  RxBool setDetails = false.obs;
  Rxn<SignedInWith> signInWith = Rxn();
  // PageController pageController = PageController();

  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: [
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );

  @override
  onInit() async {
    super.onInit();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('version!');
    print(packageInfo.version);
    tk.value = box.read('tk');
    print(tk.value);
    showHomeTutorial.value = box.read("showHomeTutorial");
    // print("showTutorial: " + showHomeTutorial.value.toString());

    // print("tk: " + tk.value.toString());
    if (tk.value == null) {
      state.value = AuthState.LOGGEDOUT;
    } else {
      //verifying token
      print("verifying token, $API_URL/auth/verify/token=$tk");
      var response =
          await http.post(Uri.parse('$API_URL/auth/verify/token=$tk'));
      if (response.statusCode == 200) {
        String uid = jsonDecode(response.body)["message"]["uid"];

        var response2 = await http.get(
          Uri.parse('$API_URL/users/$uid'),
          headers: {
            'Authorization': 'Bearer $tk',
          },
        ); // no authorization yet
        if (response2.statusCode == 200) {
          user.value = UserModel.fromJson(jsonDecode(response2.body));
          await getFcmToken();
          // await updateLastActive();
          if (user.value!.app_version != packageInfo.version) {
            await updateAppVer(packageInfo.version);
          }
          state.value = AuthState.LOGGEDIN;
          // isHome.value = false;
        } else {
          state.value = AuthState.LOGGEDOUT;
          box.remove('tk');
        }
      } else {
        state.value = AuthState.LOGGEDOUT;
        box.remove('tk');
      }
    }
  }

  updateAppVer(String app_version) async {
    Get.lazyPut(() => UserController());
    await Get.find<UserController>().updateAppVer(app_version);
  }

  getFcmToken() async {
    String fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    Get.lazyPut(() => UserController());
    if (!(fcmToken == user.value!.fcmToken)) {
      await Get.find<UserController>().updateFcmToken(fcmToken);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await Get.find<UserController>().updateFcmToken(fcmToken);
    }).onError((err) {
      // Error getting token.
    });
    print('fcm tk: ' + fcmToken.toString());
  }

  Future<void> signInWithEmailAndPw(String email, String password) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black, status: "Loading...");
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!(FirebaseAuth.instance.currentUser?.emailVerified ?? false)) {
        // showToast(isError: true, msg: "Email not verified.");
        Get.to(() => EmailVerificationScreen());
        EasyLoading.dismiss();
        return;
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      var body = {
        "name": FirebaseAuth.instance.currentUser?.displayName ?? '',
        "email": FirebaseAuth.instance.currentUser?.email,
        "hp": '',
        "profilePic": ' ',
        "isSeller": true.toString(),
        "app_version": packageInfo.version
      };
      state.value = AuthState.UNKNOWN;
      print('$API_URL/auth/signup');
      var response =
          await http.post(Uri.parse('$API_URL/auth/signup'), body: body);
      print(response.statusCode);
      if (response.statusCode > 200 && response.statusCode < 300) {
        var body = jsonDecode(response.body);
        tk.value = body['token'];
        box.write('tk', tk.value);
        user.value = UserModel.fromJson(body['user']);
        await getFcmToken();

        String address = user.value!.address;
        String hp = user.value!.hp;
        String name = user.value!.name;
        if (name == "" || address == "" || hp == "") {
          setDetails.value = true;
        }

        state.value = AuthState.LOGGEDIN;
        signInWith.value = SignedInWith.EMAIL;
        EasyLoading.dismiss();
      } else {
        //DISPLAY ERROR
        print("BACKEND AUTH ERROR");
        state.value = AuthState.LOGGEDOUT;
        EasyLoading.dismiss();
        return;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        showToast(isError: true, msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast(isError: true, msg: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        showToast(isError: true, msg: 'You entered an invalid email.');
      } else if (e.code == 'too-many-requests') {
        showToast(isError: true, msg: 'Too many requests. Try again later.');
      }
      EasyLoading.dismiss();
    }
  }

  Future<void> resendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      showToast(isError: false, msg: "Sent! Please check again.");
    } catch (e) {
      showToast(isError: true, msg: "Too many requests. Try again later");
    }
  }

  Future<void> signUpWithEmailAndPw(
      String email, String password, String reenterPw) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black, status: "Loading...");
    try {
      if (password != reenterPw) {
        showToast(isError: true, msg: "Passwords don't match!");
      }
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      // showToast(isError: false, msg: 'Please verify your email!');
      EasyLoading.dismiss();
      Get.to(() => EmailVerificationScreen());
    } on FirebaseAuthException catch (e) {
      print('error ' + e.code);
      if (e.code == 'user-not-found') {
        showToast(isError: true, msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast(isError: true, msg: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        showToast(isError: true, msg: 'You entered an invalid email.');
      } else if (e.code == 'too-many-requests') {
        showToast(isError: true, msg: 'Too many requests. Try again later.');
      } else if (e.code == 'weak-password') {
        showToast(isError: true, msg: 'Password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast(isError: true, msg: 'Email already in use.');
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }

  Future<bool> sendResetPasswordEmail(String email) async {
    print('send reset password to ' + email);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('sent!');
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        showToast(isError: true, msg: 'Invalid email.');
      }
    }
    return false;
  }

  Future<void> signOut() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black, status: "Logging out...");
    if (signInWith.value == SignedInWith.GOOGLE) {
      print("signing out from google");
      // await _googleSignIn.signOut();
    } else if (signInWith.value == SignedInWith.EMAIL) {
      await FirebaseAuth.instance.signOut();
    }

    Get.delete<UserController>();
    Get.delete<TimeslotController>();
    Get.delete<TxnController>();
    Get.delete<MissionController>();
    var response = await http.post(Uri.parse('$API_URL/auth/logout/token=$tk'));
    box.remove('tk');
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Logged out!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.offAll(LoginScreen());
      state.value = AuthState.LOGGEDOUT;
      // user.value = null;

      EasyLoading.dismiss();
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
    EasyLoading.dismiss();
  }

  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      var result =
          await http.post(Uri.parse('$API_URL/auth/delete/${user.value!.id}'));
      if (result.statusCode == 200) {
        box.remove('tk');
        showToast(isError: false, msg: 'Deleted account.');
        Get.delete<UserController>();
        Get.delete<TimeslotController>();
        Get.delete<TxnController>();
        Get.offAll(LoginScreen());
        state.value = AuthState.LOGGEDOUT;
      } else {
        showToast(
            isError: true, msg: 'Error deleting account. Try again later!');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showToast(isError: true, msg: 'Login again before deleting account');
      }
    } catch (e) {
      showToast(isError: true, msg: 'Error deleting account. Try again later!');
    }
  }

  bool isUserInfoComplete() {
    String contact = user.value?.hp ?? "";
    String address = user.value?.address ?? "";
    String name = user.value?.name ?? "";
    // print('checking if user info is complete ' +
    //     (contact == "" || address == "" || name == "").toString());

    return !(contact == "" || address == "" || name == "");
  }

  // Future<void> updateLastActive() async {
  //   print('$API_URL/users/update-last-active/uid=${user.value!.id}');
  //   var result = await http.put(
  //       Uri.parse('$API_URL/users/update-last-active/uid=${user.value!.id}'));
  //   print("UPDATE STATUS: " + result.statusCode.toString());
  //   if (result.statusCode == 200) {
  //     print('update last active success!');
  //   }
  // }
}

showToast({required bool isError, required String msg}) {
  isError
      ? Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0)
      : Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
}

  // Future<void> loginWithApple() async {
  //   print("LOGGING WITH APPLE");
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //     if (credential.email != null) {
  //       box.write('email', credential.email);
  //     }

  //     String email = box.read('email');

  //     var body = {
  //       "name":
  //           (credential.givenName ?? " ") + " " + (credential.familyName ?? ""),
  //       "email": email,
  //       "hp": ' ',
  //       "profilePic": ' ',
  //       "isSeller": true.toString(),
  //     };
  //     state.value = AuthState.UNKNOWN;
  //     var response =
  //         await http.post(Uri.parse('$API_URL/auth/signup'), body: body);
  //     if (response.statusCode > 200 && response.statusCode < 300) {
  //       var body = jsonDecode(response.body);
  //       tk.value = body['token'];
  //       box.write('tk', tk.value);
  //       user.value = UserModel.fromJson(body['user']);
  //       String address = user.value!.address;
  //       String hp = user.value!.hp;
  //       if (address == " " || hp == " ") {
  //         setDetails.value = true;
  //       }
  //       state.value = AuthState.LOGGEDIN;
  //       signInWith.value = SignedInWith.APPLE;
  //     } else {
  //       //DISPLAY ERROR
  //       print("BACKEND AUTH ERROR");
  //       state.value = AuthState.LOGGEDOUT;
  //       return;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> loginWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await _googleSignIn.signIn();
  //     print("GOOGLE SIGN IN " + googleSignInAccount.toString());
  //     if (googleSignInAccount == null) {
  //       throw Exception("Can't login!");
  //     }
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     var body = {
  //       "name": googleSignInAccount.displayName ?? ' ',
  //       "email": googleSignInAccount.email,
  //       "hp": ' ',
  //       "profilePic": googleSignInAccount.photoUrl ?? ' ',
  //       "isSeller": true.toString(),
  //     };
  //     state.value = AuthState.UNKNOWN;
  //     var response =
  //         await http.post(Uri.parse('$API_URL/auth/signup'), body: body);
  //     if (response.statusCode > 200 && response.statusCode < 300) {
  //       var body = jsonDecode(response.body);
  //       tk.value = body['token'];
  //       box.write('tk', tk.value);
  //       user.value = UserModel.fromJson(body['user']);
  //       String address = user.value!.address;
  //       String hp = user.value!.hp;
  //       if (address == " " || hp == " ") {
  //         setDetails.value = true;
  //       }
  //       state.value = AuthState.LOGGEDIN;
  //       isHome.value = false;
  //       signInWith.value = SignedInWith.GOOGLE;
  //     } else {
  //       //DISPLAY ERROR
  //       print("BACKEND AUTH ERROR");
  //       state.value = AuthState.LOGGEDOUT;
  //       return;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     rethrow;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
