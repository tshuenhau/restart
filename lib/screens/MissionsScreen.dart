import 'package:flutter/material.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/TimelineCard.dart';
import 'package:timelines/timelines.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/models/MissionModel.dart';

class MissionsScreen extends StatelessWidget {
  MissionsScreen({Key? key}) : super(key: key);

  UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    List<MissionModel> missions = user.missions;
    var kTileHeight = MediaQuery.of(context).size.height * 10 / 100;

    return SizedBox(
      width: MediaQuery.of(context).size.height,
      height: MediaQuery.of(context).size.width,
      child: Obx(
        () => ListView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 1.5 / 100,
                bottom: MediaQuery.of(context).size.height * 3 / 100),
            children: [
              GlassCard_header(
                  header: Header(
                    title: "Missions",
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 50 / 100,
                    child: Timeline.tileBuilder(
                      theme: TimelineThemeData(
                        nodePosition: 0,
                        nodeItemOverlap: true,
                        connectorTheme: ConnectorThemeData(
                          color: Colors.white.withOpacity(0.65),
                          thickness: 15.0,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 10 / 100,
                          vertical:
                              MediaQuery.of(context).size.height * 3 / 100),
                      builder: TimelineTileBuilder.connected(
                        indicatorBuilder: (context, index) {
                          MissionModel mission = user.missions[index];
                          return OutlinedDotIndicator(
                            // size: MediaQuery.of(context).size.width * 4.5 / 100,
                            color: mission.status == MISSION_STATUS.COLLECTED
                                ? Theme.of(context).primaryColor
                                : mission.status == MISSION_STATUS.INCOMPLETE ||
                                        mission.status ==
                                            MISSION_STATUS.COMPLETED
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorLight,
                            backgroundColor:
                                mission.status == MISSION_STATUS.COMPLETED
                                    ? Color.fromARGB(255, 255, 255, 255)
                                    : Colors.white,
                            borderWidth: mission.status ==
                                    MISSION_STATUS.COMPLETED
                                ? 3.0
                                : mission.status == MISSION_STATUS.INCOMPLETE
                                    ? 2.5
                                    : 3,
                          );
                        },
                        connectorBuilder: (context, index, connectorType) {
                          var color;
                          MissionModel mission = user.missions[index];
                          if (index < user.missions.length - 1 &&
                              mission.status == MISSION_STATUS.COLLECTED &&
                              missions[index + 1].status ==
                                  MISSION_STATUS.COLLECTED) {
                            color = mission.status == MISSION_STATUS.COLLECTED
                                ? Theme.of(context).primaryColor
                                : null;
                          }
                          return SolidLineConnector(
                            color: color,
                          );
                        },
                        contentsBuilder: (context, index) {
                          MissionModel mission = user.missions[index];
                          MissionModel? prevMission = null;
                          if (index > 0) {
                            prevMission = user.missions[index - 1];
                          }
                          var height;
                          if (index + 1 < missions.length - 1 &&
                              mission.status == MISSION_STATUS.INCOMPLETE &&
                              missions[index + 1].status ==
                                  MISSION_STATUS.INCOMPLETE) {
                            height = kTileHeight - 10;
                          } else {
                            height = kTileHeight + 5;
                          }
                          return SizedBox(
                            height: height,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TimelineCard(
                                exp: mission.exp,
                                missionId: mission.id,
                                missionText: mission.title,
                                isPrevMissionCollected: prevMission == null
                                    ? true
                                    : prevMission.status ==
                                        MISSION_STATUS.COLLECTED,
                                mission: mission,
                              ),
                            ),
                          );
                        },
                        itemCount: missions.length,
                      ),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 80 / 100)
            ]),
      ),
    );
  }
}

enum TimelineStatus {
  //TODO: Need this enum
  done,
  sync,
  inProgress,
  todo,
}
