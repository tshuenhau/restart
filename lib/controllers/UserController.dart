import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/MissionController.dart';
import 'package:restart/env.dart';
import 'package:restart/models/MissionModel.dart';
import 'package:restart/models/auth/UserModel.dart';

class UserController extends GetxController {
  AuthController auth = Get.find();
  List<MissionModel> missions = RxList();
  RxBool isLevelUp = RxBool(false);
  RxInt increase = 0.obs;

  @override
  onInit() async {
    // if (auth.isHome.value) {
    await getUserProfile();
    // await getMissions();
    // }

    super.onInit();
  }

  int calculateLevelUp(int level) {
    return (pow(level, 1.3) * 20).ceil();
  }

  updateAppVer(String app_version) async {
    var response = await http.put(
      Uri.parse('$API_URL/users/app_ver/${auth.user.value!.id}'),
      body: {'app_version': app_version},
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );

    if (response.statusCode == 200) {
      auth.user.value!.app_version = app_version;
    } else {
      print("unable to update fcm token");
    }
  }

  getUserProfile() async {
    var response = await http.get(
      Uri.parse('$API_URL/users/${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk.value}',
      },
    );
    if (response.statusCode == 200) {
      auth.user.value = UserModel.fromJson(jsonDecode(response.body));
      print('user ' + auth.user.value.toString());
      update();
    } else {}
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

  Future<void> updateFcmToken(String fcmToken) async {
    var response = await http.put(
      Uri.parse('$API_URL/users/fcm/${auth.user.value!.id}'),
      body: {'fcm_token': fcmToken},
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );

    if (response.statusCode == 200) {
      auth.user.value!.fcmToken = fcmToken;
    } else {
      print("unable to update fcm token");
    }
  }

  Future<bool> updateUserProfile(
      String name, String hp, String address, String addressDetails) async {
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
      return true;
    } else if (response.statusCode == 400) {
      if (jsonDecode(response.body)["message"] == 'invalid-hp') {
        Fluttertoast.showToast(
            msg: "Invalid Number!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        EasyLoading.dismiss();

        return false;
      } else if (jsonDecode(response.body)["message"] == 'invalid-loc') {
        Fluttertoast.showToast(
            msg: "Invalid Address!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        EasyLoading.dismiss();

        return false;
      }
    }
    return false;
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
    missions.clear();
    var response = await http.get(
      Uri.parse('$API_URL/users/missions/uid=${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      Map<String, dynamic> m = body['message'];
      for (String key in m.keys) {
        Map<String, dynamic> value = m[key];
        value["id"] = key;
        MissionModel mission = MissionModel.fromJson(value);
        missions.add(mission);
      }
      missions.sort((x, y) => x.code.compareTo(y.code));
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

  collectPoints(String missionId) async {
    print('$API_URL/users/collect-points/uid=${auth.user.value!.id}');
    var response = await http.put(
        Uri.parse(
          '$API_URL/users/collect-points/uid=${auth.user.value!.id}',
        ),
        headers: {
          'Authorization': 'Bearer ${auth.tk}',
        },
        body: {
          'id': missionId
        });
    if (response.statusCode == 200) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Error claiming EXP. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  updateForest() async {
    List<int> forest = auth.user.value!.forest;
    print(forest);
    List<int> emptyPositions = [];
    for (int i = 0; i < forest.length; i++) {
      if (forest[i] == 0) {
        emptyPositions.add(i);
      }
    }
    int newTree = getNewTree();
    //get random position among empty plots
    if (emptyPositions.isNotEmpty) {
      int position = Random().nextInt(emptyPositions.length);

      int newTree = getNewTree();
      forest[emptyPositions[position]] = newTree;
      var response = await http.put(
          Uri.parse(
            '$API_URL/users/update-forest/uid=${auth.user.value!.id}',
          ),
          headers: {
            'Authorization': 'Bearer ${auth.tk}',
          },
          body: {
            'forest': jsonEncode(forest)
          });
      if (response.statusCode == 200) {
        await getUserProfile();
      }
    }
  }

  int getNewTree() {
    return Random().nextInt(3) + 1;
  }
}
