import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/TimelineCard.dart';
import 'package:timelines/timelines.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/models/MissionModel.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MissionsScreen extends StatefulWidget {
  MissionsScreen(
      {required this.fullScreenKey, required this.isOnPageTurning, Key? key})
      : super(key: key);

  bool isOnPageTurning;
  GlobalKey fullScreenKey;
  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  GlobalKey progressKey = GlobalKey();
  GlobalKey helpKey = GlobalKey();
  GlobalKey missionKey = GlobalKey();
  GlobalKey blankKey = GlobalKey();
  GlobalKey totalBottlesKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    createTutorial();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> executeAfterBuild() async {
    if (!widget.isOnPageTurning) {
      await Future.delayed(Duration.zero, showTutorial);
    }
    // this code will get executed after the build method
    // because of the way async functions are scheduled
  }

  @override
  Widget build(BuildContext context) {
    // print("Turning? " + widget.isOnPageTurning.toString());
    UserController user = Get.find();
    List<MissionModel> missions = user.missions;

    executeAfterBuild();

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

  void showTutorial() {
    // if (box.read("showHomeTutorial") == false) {
    //   return;
    // } else {
    if (mounted) {
      tutorialCoachMark.show(context: context);
    }
    // }
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.blue,
      textSkip: "SKIP",
      // paddingFocus: 5,
      opacityShadow: 0.85,
      onFinish: () {
        // box.write("showHomeTutorial", false);
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        // box.write("showHomeTutorial", false);

        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "fullScreen",
        keyTarget: widget.fullScreenKey,
        alignSkip: Alignment.topRight,
        // targetPosition: TargetPosition(const Size(0, 0), Offset(0, -1)),
        shape: ShapeLightFocus.Circle,
        enableOverlayTab: true,
        radius: 0,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 45 / 100),
                  const Text(
                    "Here's where you'll complete missions and earn experience!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 50 / 100),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "totalBottles",
        keyTarget: totalBottlesKey,
        enableOverlayTab: true,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.Circle,
        radius: DEFAULT_RADIUS,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.55 / 100),
                  const Text(
                    "The total number if bottles you've recycled will show up here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  const Text(
                    "It's 0 now... but we have high hopes for you!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "mission",
        keyTarget: missionKey,
        enableOverlayTab: true,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.55 / 100),
                  const Text(
                    "These are missions for you to complete.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 1 / 100),
                  // const Text(
                  //   "After we have collected the bottles from you, the total bottles recycled count will increase. ",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //   ),
                  // ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  const Text(
                    "When you've recycled enough bottles, they will light up. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  const Text(
                    "Then, with a simple tap you'll be able to claim some experience points. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    // targets.add(
    //   TargetFocus(
    //     identify: "timeline",
    //     keyTarget: progressKey,
    //     enableOverlayTab: true,
    //     alignSkip: Alignment.topRight,
    //     shape: ShapeLightFocus.RRect,
    //     radius: DEFAULT_RADIUS,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.bottom,
    //         builder: (context, controller) {
    //           return Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               SizedBox(
    //                   height: MediaQuery.of(context).size.height * 2.55 / 100),
    //               const Text(
    //                 "Here's your forest.",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                     color: Colors.white, fontWeight: FontWeight.bold),
    //               ),
    //               SizedBox(
    //                   height: MediaQuery.of(context).size.height * 1 / 100),
    //               const Text(
    //                 "It might be empty now, but recycle with us and soon it'll into turn a lush green forest!",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               )
    //             ],
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );

    return targets;
  }
}
