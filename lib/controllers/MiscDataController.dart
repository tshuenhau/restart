import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../env.dart';
import '../models/MissionModel.dart';
import 'AuthController.dart';

class MiscDataController extends GetxController {
  RxMap<String, dynamic> collectionDriveData = RxMap();
  @override
  onInit() async {
    super.onInit();
    await getCollectionDriveData();
  }

  AuthController auth = Get.find();
  getCollectionDriveData() async {
    var response = await http
        .get(Uri.parse('$API_URL/misc/get-collection-drive'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    });
    if (response.statusCode == 200) {
      print("FUOSJAOEF");
      print(jsonDecode(response.body)['message']);
      collectionDriveData['text'] =
          jsonDecode(response.body)['message']['text'];
      collectionDriveData['expire'] =
          jsonDecode(response.body)['message']['expire'];
      print(collectionDriveData);
    }
  }
}
