import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/env.dart';
import 'package:restart/models/TimeslotModel.dart';

class TimeslotController extends GetxController {
  AuthController auth = Get.find();
  List<TimeslotModel> availTimeslots = RxList();
  RxBool hasGottenTimeslots = RxBool(false);
  DateTime currentDate = DateTime.now();
  RxBool isNoMoreSlots = RxBool(false);
  RxBool alrShowNoSlots = RxBool(false);
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
    if (isNoMoreSlots.value) {
      return null;
    }
    hasGottenTimeslots.value = false;
    isNoMoreSlots.value = false;
    var response = await http.get(Uri.parse('$TIMESLOTS_API_URL/'), headers: {
      "address": auth.user.value!.address,
      "tk": auth.tk.value!,
      "date": currentDate.toString(),
    });
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      if (body.isEmpty) {
        isNoMoreSlots.value = true;
      } else {
        for (int i = 0; i < body.length; i++) {
          TimeslotModel timeslot = TimeslotModel.fromJson(body[i]);
          if (i == 0) {
            if (timeslot.time.isBefore(currentDate)) {
              isNoMoreSlots.value = true;
            }
          }
          if (timeslot.time.isAfter(DateTime.now())) {
            availTimeslots.add(timeslot);
          }
        }
        // print(currentDate);
        // print(availTimeslots.last.time);
        if (currentDate.isAfter(availTimeslots.last.time)) {
          isNoMoreSlots.value = true;
        }
        availTimeslots.sort((a, b) => a.time.isBefore(b.time) ? -1 : 1);
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
      availTimeslots.clear();
      Get.back();
    }
  }

  bookTimeslot(TimeslotModel timeslot, String address) async {
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
      } else if (error['message'] == 'invalid-hp') {
        Fluttertoast.showToast(
            msg: "Add your phone number before booking!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (error['message'] == 'timeslot-already-taken') {
        Fluttertoast.showToast(
            msg: "Time slot has been taken! Please schedule another slot!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return null;
    }
  }

  Future<TimeslotModel?> getTimeslotByDate(DateTime date) async {
    print(date);
    print(auth.tk);
    var response = await http
        .get(Uri.parse('$API_URL/timeslots/date=${date.toUtc()}'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    });
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      print(body);
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
