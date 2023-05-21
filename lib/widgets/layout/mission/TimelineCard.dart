import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/screens/ExperienceUpScreen.dart';
import 'package:restart/screens/MissionsScreen.dart';
import 'package:restart/models/MissionModel.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExperienceUpScreen(
                                          mission: mission)));
                              await userController.collectPoints(missionId);
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
