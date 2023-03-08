import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'package:restart/models/auth/UserModel.dart';
import 'dart:convert';
import 'package:restart/controllers/AuthController.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserController extends GetxController {
  Rxn<String> uid = Rxn<String>();
  AuthController auth = Get.put(AuthController());

  @override
  onInit() async {
    super.onInit();
  }

  getUserProfile() async {
    var response =
        await http.get(Uri.parse('$API_URL/users/${auth.user.value!.id}'));
    if (response.statusCode == 200) {
      auth.user.value = UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('No user found!');
    }
  }

  Future<UserModel> getUser(String uid) async {
    var response = await http.get(
      Uri.parse('$API_URL/users/$uid'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      var body = response.body;
      UserModel user = UserModel.fromJson(jsonDecode(body));
      return user;
    } else {
      throw Exception("Can't get user!");
    }
  }

  Future<void> updateUserProfile(String name, String hp, String address) async {
    var response = await http.put(
      Uri.parse('$API_URL/users/${auth.user.value!.id}'),
      body: {
        'name': name,
        'hp': hp,
        'address': address,
      },
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      auth.user.value = await getUser(auth.user.value!.id);
      Fluttertoast.showToast(
          msg: "Updated Profile Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (response.statusCode == 400) {
      print(jsonDecode(response.body)['message']);
      if (jsonDecode(response.body)["message"] == 'invalid-hp') {
        Fluttertoast.showToast(
            msg: "Invalid Number!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (jsonDecode(response.body)["message"] == 'invalid-loc') {
        Fluttertoast.showToast(
            msg: "Invalid Address!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
