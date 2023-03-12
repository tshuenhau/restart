import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'dart:convert';
import 'package:restart/controllers/AuthController.dart';

class TimeslotController extends GetxController {
  AuthController auth = Get.find();
  List<TimeslotModel> timeslots = RxList();
  @override
  onInit() async {
    super.onInit();
    await getTimeslots();
  }

  @override
  onReady() async {
    await getTimeslots();
  }

  getTimeslots() async {
    print("getting time slots");
    var response = await http.get(Uri.parse('$TIMESLOTS_API_URL/'), headers: {
      "userLocation": auth.user.value!.address,
      "tk": auth.tk.value!
    });
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        TimeslotModel timeslot = TimeslotModel.fromJson(body[i]);
        timeslots.add(timeslot);
      }
    }
    print(timeslots[0].time.toString());
  }

  bookTimeslot() async {}
}
