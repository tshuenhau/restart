import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/ExperienceUpScreen.dart';
import 'package:restart/screens/MissionsScreen.dart';
import 'package:restart/models/MissionModel.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';

class TimelineCard extends StatelessWidget {
  TimelineCard(
      {required this.exp,
      required this.missionId,
      required this.missionText,
      Key? key,
      required this.isPrevMissionCollected,
      required this.mission})
      : super(key: key);
  int exp;
  String missionId;
  String missionText;
  bool isPrevMissionCollected;
  MissionModel mission;
  AuthController auth = Get.find();
  UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    UserController user = Get.find();
    bool isDisabled = (mission.status == MISSION_STATUS.COMPLETED &&
            !isPrevMissionCollected) ||
        mission.status == MISSION_STATUS.INCOMPLETE ||
        mission.status == MISSION_STATUS.COLLECTED;
    return Padding(
      padding:
          EdgeInsets.only(left: MediaQuery.of(context).size.width * 3.5 / 100),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
        clipBehavior: Clip.hardEdge,
        child: Container(
            height: MediaQuery.of(context).size.height * 7 / 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.white.withOpacity(0.72),
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 8 / 100),
                  child: Text(
                    missionText,
                    style: TextStyle(
                        color: !isDisabled
                            ? Theme.of(context).primaryColor.withOpacity(1)
                            : Theme.of(context).primaryColor.withOpacity(0.7)),
                  ),
                )),
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).primaryColorDark,
                      onTap: isDisabled
                          ? null
                          : () async {
                              bool isLevelUp = auth.user.value!.current_points +
                                      mission.exp >=
                                  auth.user.value!.exp_for_level;
                              EasyLoading.show(status: "Completing mission...");
                              var res = await user.collectPoints(mission.id);
                              EasyLoading.dismiss();

                              if (res) {
                                auth.pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 350),
                                    curve: Curves.easeOut);
                                await user.getUserProfile();
                                await user.getMissions();
                              }

                              if (isLevelUp) {
                                print('is level up: ' + isLevelUp.toString());
                                user.isLevelUp.value = true;
                                await user.updateForest();
                              }
                            },
                      child: Container(
                          color: isDisabled
                              ? Colors.white.withOpacity(0.4)
                              : Theme.of(context).primaryColor.withOpacity(0.8),
                          width: MediaQuery.of(context).size.width * 18 / 100,
                          padding: EdgeInsets.only(
                              right:
                                  MediaQuery.of(context).size.width * 1 / 100),
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: Text(
                            mission.exp.toString() + " exp",
                            style: TextStyle(
                                color: isDisabled
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(1)
                                    : Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
