import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'dart:convert';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:restart/models/TimeslotModel.dart';

class TimeslotController extends GetxController {
  AuthController auth = Get.find();
  List<TimeslotModel> availTimeslots = RxList();
  RxBool hasGottenTimeslots = RxBool(false);
  @override
  onInit() async {
    print("wtf is going on");
    // await getTimeslots();
    super.onInit();
  }

  @override
  onReady() async {
    print("time slot controller is on ready");
    // await getTimeslots();
  }

  getTimeslots() async {
    print("getting time slots");
    hasGottenTimeslots.value = false;
    availTimeslots.clear();
    var response = await http.get(Uri.parse('$TIMESLOTS_API_URL/'),
        headers: {"address": auth.user.value!.address, "tk": auth.tk.value!});
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        TimeslotModel timeslot = TimeslotModel.fromJson(body[i]);
        availTimeslots.add(timeslot);
      }
      hasGottenTimeslots.value = true;
    } else {
      Fluttertoast.showToast(
          msg: "Error getting time slots. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.back();
    }
  }

  bookTimeslot(TimeslotModel timeslot, String address) async {
    //TODO: AFTER BOOKING STILL NEED TO CREATE TXN
    var response = await http
        .put(Uri.parse('$API_URL/timeslots/id=${timeslot.id}'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    }, body: {
      "uid": auth.user.value!.id,
      "location": address,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var error = jsonDecode(response.body);
      print("ERR " + error.toString());
      if (error['message'] == 'invalid-loc') {
        Fluttertoast.showToast(
            msg: "Add your address before booking!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return null;
    }
  }

  Future<TimeslotModel?> getTimeslotByDate(DateTime date) async {
    var response =
        await http.get(Uri.parse('$API_URL/timeslots/date=$date'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    });
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      TimeslotModel timeslot = TimeslotModel.fromJson(body["message"]);
      return timeslot;
    } else {
      return null;
    }
  }

  clearTimeslot(TimeslotModel timeslot) async {
    var response = await http
        .put(Uri.parse('$API_URL/timeslots/id=${timeslot.id}/clear'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    });
    if (response.statusCode == 200) {
      print("time slot is open now");
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
