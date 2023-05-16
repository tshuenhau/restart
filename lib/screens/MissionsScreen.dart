import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/TimelineCard.dart';
import 'package:timelines/timelines.dart';
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

  late TutorialCoachMark tutorialCoachMark;

  // late final ValueNotifier<bool> notifier =
  //     ValueNotifier(widget.isOnPageTurning)
  //       ..addListener(() {
  //         // if value is true
  //         if (notifier.value) {
  //           debugPrint("value is true here, perform any operation");
  //           Future.delayed(Duration.zero, showTutorial);
  //         }
  //       });

  @override
  void initState() {
    createTutorial();

    // Future.delayed(Duration(milliseconds: 50),
    //     showTutorial); //! need to find a way to tell when a page has fully navigated

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void afterBuild() {
  //   // executes after build is done
  //   print("here");
  //   if (!widget.isOnPageTurning) {
  //     Future.delayed(Duration.zero, showTutorial);
  //   }
  // }

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

    executeAfterBuild();

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
              SizedBox(width: 0, height: 0, key: blankKey),
              GlassCard_header(
                  header: Header(
                    title: "Missions",
                    trailing: IconButton(
                        key: helpKey,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {}, //TODO: Add modal
                        icon: const Icon(Icons.help_outline_rounded)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 4 / 100,
                        ),
                        Text("Total Bottles: 43"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width * 100 / 100,
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
                                horizontal: MediaQuery.of(context).size.width *
                                    10 /
                                    100,
                                vertical: MediaQuery.of(context).size.height *
                                    3 /
                                    100),
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
                              connectorBuilder:
                                  (context, index, connectorType) {
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
                                  key: index == 0 ? missionKey : GlobalKey(),
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
                      ],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 80 / 100)
            ]));
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
                    "Here's where you complete missions and earn exp!",
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
                    "Here's your forest.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  const Text(
                    "It might be empty now, but recycle with us and soon it'll into turn a lush green forest!",
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

    return targets;
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
