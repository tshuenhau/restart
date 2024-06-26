import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/models/MissionModel.dart';

class TimelineCard extends StatefulWidget {
  TimelineCard(
      {required this.pageController,
      required this.exp,
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
  late PageController pageController;

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> {
  late bool isDisabled;
  @override
  initState() {
    isDisabled = (widget.mission.status == MISSION_STATUS.COMPLETED &&
            !widget.isPrevMissionCollected) ||
        widget.mission.status == MISSION_STATUS.INCOMPLETE ||
        widget.mission.status == MISSION_STATUS.COLLECTED;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    UserController user = Get.find();

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
                    widget.missionText,
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
                              setState(() {
                                isDisabled = true;
                              });
                              bool isLevelUp = auth.user.value!.current_points +
                                      widget.mission.exp >=
                                  auth.user.value!.exp_for_level;
                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black,
                                  status: "Completing mission...");
                              var res =
                                  await user.collectPoints(widget.mission.id);
                              EasyLoading.dismiss();

                              if (res) {
                                widget.pageController.animateToPage(0,
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
                            widget.mission.exp.toString() + " exp",
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
