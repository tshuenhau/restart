import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'dart:convert';
import 'package:restart/controllers/AuthController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';

class TimeslotController extends GetxController {
  AuthController auth = Get.find();
  List<TimeslotModel> availTimeslots = RxList();
  RxBool hasGottenTimeslots = RxBool(false);
  @override
  onInit() async {
    super.onInit();
  }

  @override
  onReady() async {
    await getTimeslots();
  }

  getTimeslots() async {
    hasGottenTimeslots.value = false;
    print("getting time slots");
    availTimeslots.clear();
    var response = await http.get(Uri.parse('$TIMESLOTS_API_URL/'),
        headers: {"address": auth.user.value!.address, "tk": auth.tk.value!});
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        TimeslotModel timeslot = TimeslotModel.fromJson(body[i]);
        availTimeslots.add(timeslot);
      }
    }
    hasGottenTimeslots.value = true;
  }

  bookTimeslot(TimeslotModel timeslot, String address) async {
    //TODO: AFTER BOOKING STILL NEED TO CREATE TXN
    print(address);
    List<Location> location = await locationFromAddress(address,
        localeIdentifier: 'en_SG'); //THIS ISNT WORKING
    print(location);
    var response = await http
        .put(Uri.parse('$API_URL/timeslots/id=${timeslot.id}'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    }, body: {
      "uid": auth.user.value!.id,
      "location": jsonEncode([location[0].latitude, location[0].longitude])
    });
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "You have booked your time slot!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      getTimeslots();
    } else {
      Fluttertoast.showToast(
          msg: "Unable to book. Try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
