import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restart/models/auth/UserModel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

enum AuthState { LOGGEDIN, LOGGEDOUT, UNKNOWN }

class AuthController extends GetxController {
  final box = GetStorage();
  Rx<AuthState> state = AuthState.UNKNOWN.obs;
  late User? googleUser;
  Rxn<UserModel> user = Rxn<UserModel>();
  RxnString tk = RxnString(null);
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  onInit() async {
    super.onInit();
    print(this.state.value);
    tk.value = box.read('tk');
    if (tk.value == null) {
      state.value = AuthState.LOGGEDOUT;
    } else {
      //verifying token
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
        user.value = UserModel.fromJson(jsonDecode(response2.body));
        state.value = AuthState.LOGGEDIN;
      } else {
        state.value = AuthState.LOGGEDOUT;
        box.remove('tk');
      }
    }
  }

  Future<void> login() async {
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
      print(API_URL);
      var response =
          await http.post(Uri.parse('$API_URL/auth/signup'), body: body);

      print(response.statusCode);
      if (response.statusCode > 200 && response.statusCode < 300) {
        var body = jsonDecode(response.body);
        tk.value = body['token'];
        box.write('tk', tk.value);
        user.value = UserModel.fromJson(body['user']);
        state.value = AuthState.LOGGEDIN;
        Get.to(const HomeScreen());
      } else {
        //DISPLAY ERROR
        return;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();

    // EasyLoading.show(status: 'Logging out...');
    try {
      var response =
          await http.post(Uri.parse('$API_URL/auth/logout/token=$tk'));
      box.remove('tk');

      // EasyLoading.dismiss();
      // Fluttertoast.showToast(
      //     msg: "Logged out!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      // Get.offAll(const LoginPage());
    } catch (e) {
      //TODO: Display logout error
      // Fluttertoast.showToast(
      //     msg: "Unable to logout. Try again!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }
}