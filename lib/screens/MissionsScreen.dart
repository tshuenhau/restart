import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/models/MissionModel.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/TimelineCard.dart';
import 'package:timelines/timelines.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../widgets/GlassCards/GlassCard.dart';

class MissionsScreen extends StatefulWidget {
  MissionsScreen(
      {required this.pageController,
      required this.fullScreenKey,
      required this.isOnPageTurning,
      Key? key})
      : super(key: key);

  bool isOnPageTurning;
  GlobalKey fullScreenKey;
  PageController pageController;
  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  GlobalKey progressKey = GlobalKey();
  GlobalKey helpKey = GlobalKey();
  GlobalKey missionKey = GlobalKey();
  GlobalKey blankKey = GlobalKey();
  GlobalKey totalBottlesKey = GlobalKey();
  final box = GetStorage();

  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    // box.write("showMissionsTutorial", null);
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

  AuthController auth = Get.find();
  UserController user = Get.find();

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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 16 / 100,
                              child: AutoSizeText(
                                "Collect 30XP",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              )),
                          onPressed: () async {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ExperienceUpScreen(
                            //             current_points:
                            //                 auth.user.value!.current_points,
                            //             exp_for_level:
                            //                 auth.user.value!.exp_for_level,
                            //             level: auth.user.value!.level,
                            //             mission: missions[1])));
                            print("WAT " +
                                (auth.user.value!.current_points +
                                        missions[1].exp)
                                    .toString());
                            user.increase.value += missions[1].exp;
                            print(auth.user.value!.exp_for_level);
                            bool isLevelUp = auth.user.value!.current_points +
                                    missions[1].exp >
                                auth.user.value!.exp_for_level;
                            EasyLoading.show(
                              maskType: EasyLoadingMaskType.black,
                              status: "Completing mission...",
                            );
                            var res = await user
                                .collectPoints('6474dcdfd203e19b334b5414');
                            EasyLoading.dismiss();

                            if (res) {
                              widget.pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeOut);
                              await user.getUserProfile();
                              await user.getMissions();
                            }

                            if (isLevelUp) {
                              user.isLevelUp.value = true;
                              await user.updateForest();
                            }
                          },
                        ),
                        // ElevatedButton(
                        //   child: SizedBox(
                        //       width:
                        //           MediaQuery.of(context).size.width * 16 / 100,
                        //       child: AutoSizeText(
                        //         "Add Tree",
                        //         maxLines: 1,
                        //         textAlign: TextAlign.center,
                        //       )),
                        //   onPressed: () async {
                        //     await user.updateForest();
                        //   },
                        // ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 4 / 100,
                        ),
                        Container(
                            height:
                                MediaQuery.of(context).size.height * 7 / 100,
                            width: MediaQuery.of(context).size.width * 68 / 100,
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                            ),
                            key: totalBottlesKey,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        7 /
                                        100,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              4 /
                                              100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                alignment: Alignment.center,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    "assets/icons/logo_white.png")),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1 /
                                              100,
                                        )
                                      ],
                                    )),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.4),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                DEFAULT_RADIUS))),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                6 /
                                                100),
                                    child: AutoSizeText("Bottles recycled: ",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.72),
                                        borderRadius: BorderRadius.only(
                                            topRight:
                                                Radius.circular(DEFAULT_RADIUS),
                                            bottomRight: Radius.circular(
                                                DEFAULT_RADIUS))),
                                    width: MediaQuery.of(context).size.width *
                                        18 /
                                        100,
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                1 /
                                                100),
                                    alignment: Alignment.center,
                                    height: double.infinity,
                                    child: Text(
                                      // "23"
                                      auth.user.value!.total_weight.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).primaryColor),
                                    )),
                              ],
                            )),
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
                                MissionModel mission = user.missions[index];
                                return OutlinedDotIndicator(
                                  key: index == 0 ? progressKey : GlobalKey(),

                                  // size: MediaQuery.of(context).size.width * 4.5 / 100,
                                  color: mission.status ==
                                          MISSION_STATUS.COLLECTED
                                      ? Theme.of(context).primaryColor
                                      : mission.status ==
                                                  MISSION_STATUS.INCOMPLETE ||
                                              mission.status ==
                                                  MISSION_STATUS.COMPLETED
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).primaryColorLight,
                                  backgroundColor:
                                      mission.status == MISSION_STATUS.COMPLETED
                                          ? Color.fromARGB(255, 255, 255, 255)
                                          : Colors.white,
                                  borderWidth:
                                      mission.status == MISSION_STATUS.COMPLETED
                                          ? 3.0
                                          : mission.status ==
                                                  MISSION_STATUS.INCOMPLETE
                                              ? 2.5
                                              : 3,
                                );
                              },
                              connectorBuilder:
                                  (context, index, connectorType) {
                                var color;
                                MissionModel mission = user.missions[index];
                                if (index < user.missions.length - 1 &&
                                    mission.status ==
                                        MISSION_STATUS.COLLECTED &&
                                    missions[index + 1].status ==
                                        MISSION_STATUS.COLLECTED) {
                                  color =
                                      mission.status == MISSION_STATUS.COLLECTED
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
                                    mission.status ==
                                        MISSION_STATUS.INCOMPLETE &&
                                    missions[index + 1].status ==
                                        MISSION_STATUS.INCOMPLETE) {
                                  height = kTileHeight;
                                } else {
                                  height = kTileHeight;
                                }
                                return SizedBox(
                                  key: index == 0 ? missionKey : GlobalKey(),
                                  height: height,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TimelineCard(
                                      pageController: widget.pageController,
                                      exp: mission.exp,
                                      missionId: mission.id,
                                      missionText: mission.title,
                                      isPrevMissionCollected:
                                          prevMission == null
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
                      ],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 80 / 100)
            ]),
      ),
    );
  }

  void showTutorial() {
    if (box.read("showMissionsTutorial") == false) {
      return;
    } else {
      tutorialCoachMark.show(context: context);
    }
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.blue,
      textSkip: "SKIP",
      // paddingFocus: 5,
      opacityShadow: 0.85,
      onFinish: () {
        box.write("showMissionsTutorial", false);
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
        box.write("showMissionsTutorial", false);

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
                    "Welcome to the missions page.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                  const Text(
                    "Here's where you'll complete missions and gain experience points.",
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
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        paddingFocus: 40,
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
                    "The total number of bottles you've recycled will show up here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
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
                    "This is the first missions for you to complete.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  const Text(
                    "Please collect and clean 10 PET bottles and schedule a collection with us.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                  const Text(
                    "After they've been collected you can return here to claim your experience points. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

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
                    "Good luck completing missions!",
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
