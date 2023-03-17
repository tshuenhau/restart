import 'package:flutter/material.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/TimelineCard.dart';
import 'package:timelines/timelines.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kTileHeight = MediaQuery.of(context).size.height * 10 / 100;
    List missions = [
      Mission("5 bottles", 5, TimelineStatus.done, true),
      Mission("20 bottles", 20, TimelineStatus.done, false),
      Mission("50 bottles", 70, TimelineStatus.inProgress, true),
      Mission("100 bottles", 200, TimelineStatus.todo, true)
    ];

    return SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.width,
        child: ListView(
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
                          Mission mission = missions[index];
                          return OutlinedDotIndicator(
                            // size: MediaQuery.of(context).size.width * 4.5 / 100,
                            color: mission.isDone
                                ? Theme.of(context).primaryColor
                                : mission.isInProgress
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColorLight,
                            backgroundColor: mission.isDone
                                ? Color.fromARGB(255, 255, 255, 255)
                                : mission.isInProgress
                                    ? Colors.white
                                    : Colors.white,
                            borderWidth: mission.isDone
                                ? 3.0
                                : mission.isInProgress
                                    ? 2.5
                                    : 3,
                          );
                        },
                        connectorBuilder: (context, index, connectorType) {
                          var color;
                          Mission mission = missions[index];
                          if (index + 1 < missions.length - 1 &&
                              mission.isDone &&
                              missions[index + 1].isDone) {
                            color = mission.isDone
                                ? Theme.of(context).primaryColor
                                : null;
                          }
                          return SolidLineConnector(
                            color: color,
                          );
                        },
                        contentsBuilder: (context, index) {
                          Mission mission = missions[index];
                          var height;
                          if (index + 1 < missions.length - 1 &&
                              mission.isInProgress &&
                              missions[index + 1].isInProgress) {
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
                                missionText: mission.missionText,
                                status: mission.status,
                                isDisabled: mission.isClaimed,
                              ),
                            ),
                          );
                        },
                        itemCount: missions.length,
                      ),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 80 / 100)
            ]));
  }
}

enum TimelineStatus {
  //TODO: Need this enum
  done,
  sync,
  inProgress,
  todo,
}

class Mission {
  //TODO: Temp class coz im not sure how you wanna store the missions
  String missionText;
  int exp;
  TimelineStatus status;
  bool isClaimed;
  bool get isDone => status == TimelineStatus.done;
  bool get isInProgress => status == TimelineStatus.inProgress;

  Mission(this.missionText, this.exp, this.status, this.isClaimed);
}
