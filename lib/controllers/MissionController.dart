import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../env.dart';
import '../models/MissionModel.dart';
import 'AuthController.dart';

class MissionController extends GetxController {
  RxList<MissionModel> missions = RxList();
  @override
  onInit() async {
    super.onInit();
  }

  AuthController auth = Get.find();
  getAllMissions() async {
    var response = await http.get(Uri.parse('$API_URL/missions'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    });
    if (response.statusCode == 200) {
      print("Got missions");
      List<dynamic> body = jsonDecode(response.body)["message"];
      print(body);
      for (int i = 0; i < body.length; i++) {
        MissionModel mission = MissionModel.fromJson(body[i]);
        missions.add(mission);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Error getting missions! Restart app.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.back();
    }
  }
}
