import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'package:restart/models/auth/UserModel.dart';
import 'dart:convert';
import 'package:restart/controllers/AuthController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart/models/MissionModel.dart';

class UserController extends GetxController {
  Rxn<String> uid = Rxn<String>();
  AuthController auth = Get.put(AuthController());
  List<MissionModel> missions = RxList();

  @override
  onInit() async {
    await getMissions();
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

  Future<void> updateUserProfile(
      String name, String hp, String address, String addressDetails) async {
    print(address);
    var response = await http.put(
      Uri.parse('$API_URL/users/${auth.user.value!.id}'),
      body: {
        'name': name,
        'hp': hp,
        'address': address,
        'addressDetails': addressDetails,
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

  updatePoints(int points, double weight) async {
    var response = await http.put(
      Uri.parse('$API_URL/users/${auth.user.value!.id}'),
      body: {
        "points": points,
        "weight": weight,
      },
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
  }

  getMissions() async {
    print('calling api to get missions');
    var response = await http.get(
      Uri.parse('$API_URL/users/missions/uid=${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      Map<String, dynamic> m = body['message'];
      for (String key in m.keys) {
        Map<String, dynamic> value = m[key];
        value["id"] = key;
        print(value);
        MissionModel mission = MissionModel.fromJson(value);
        missions.add(mission);
      }

      missions.sort((x, y) => x.code.compareTo(y.code));
      print(missions);
    } else {
      Fluttertoast.showToast(
          msg: "Error getting missions. Restart application!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
