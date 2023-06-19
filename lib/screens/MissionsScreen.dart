import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/MissionCard.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/MissionController.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MissionsScreen extends StatefulWidget {
  MissionsScreen({
    Key? key,
    required this.pageController,
    required this.fullScreenKey,
    required this.isOnPageTurning,
  }) : super(key: key);
  bool isOnPageTurning;
  GlobalKey fullScreenKey;
  PageController pageController;

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  GlobalKey helpKey = GlobalKey();
  GlobalKey missionsKey = GlobalKey();
  GlobalKey blankKey = GlobalKey();

  final box = GetStorage();

  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createTutorial();

    // box.write("showMissionsTutorial", null);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAnalytics.instance.setCurrentScreen(
        screenName: 'Missions Screen',
        screenClassOverride: 'Screens',
      );
    });
  }

  MissionController missionController = Get.put(MissionController());

  Future<void> executeAfterBuild() async {
    if (!widget.isOnPageTurning) {
      await Future.delayed(Duration.zero, showTutorial);
    }
    // this code will get executed after the build method
    // because of the way async functions are scheduled
  }

  @override
  Widget build(BuildContext context) {
    executeAfterBuild();

    return SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.5 / 100,
              bottom: MediaQuery.of(context).size.height * 3 / 100),
          child: GlassCard_header(
              header: Header(
                  title: "Missions",
                  trailing: IconButton(
                    key: helpKey,
                    icon: Icon(Icons.help_outline_outlined,
                        color: Theme.of(context).primaryColor),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => GlassCard(
                              height:
                                  MediaQuery.of(context).size.height * 70 / 100,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            5 /
                                            100,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            3 /
                                            100),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "How Our Missions Work",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Missions can be completed by recycling large amounts of PET bottles in a single collection."),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  2 /
                                                  100),
                                          Text(
                                              "Simply collect and clean as many PET bottles as you can before scheduling a collection. The more you recycle at once the more you points you'll receive and the faster you'll level up."),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  2 /
                                                  100),
                                          Text(
                                              "Our collectors will weigh the bottles when they arrive. You'll then receive a notification and points will automatically be creditted to your account."),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  2 /
                                                  100),
                                          RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                        TextSpan(
                                                            text:
                                                                "Since PET bottles come in all shapes and sizes, it'll be hard for you to estimate their weight. But we ask that you collect at least"),
                                                      ] +
                                                      MINIMUM_QUANTITY +
                                                      [
                                                        TextSpan(
                                                            text:
                                                                " PET bottles for each collection you schedule."),
                                                      ])),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  2 /
                                                  100),
                                          Text(
                                              "Not sure what's the weight of your bottles? Don't worry, just collect as many as you can!"),
                                        ],
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              30 /
                                              100,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Back",
                                            ),
                                          ))
                                    ]),
                              ),
                            )),
                  )),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 100),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 3.5 / 100,
                    ),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 5 / 100,
                            vertical:
                                MediaQuery.of(context).size.width * 3.5 / 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                          color: Colors.white.withOpacity(0.72),
                        ),
                        height: MediaQuery.of(context).size.height * 18 / 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: Text(
                                  "Complete missions by recycling the stated weight in a single collection.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                            Center(
                              child: Text(
                                  "The more you recycle in one go, the more points you'll receive!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  (ListView.builder(
                    key: missionsKey,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return MissionCard(
                        weight: missionController.missions[i].weight,
                        exp: missionController.missions[i].exp,
                      );
                    },
                    itemCount: missionController.missions.length,
                  )),
                ]),
              ),
              height: MediaQuery.of(context).size.height * 85 / 100),
        ));
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
                    "Here's where you'll be able to view the various missions that are available for you to complete.",
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
        identify: "missions",
        keyTarget: missionsKey,
        enableOverlayTab: true,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.55 / 100),
                  const Text(
                    "These are the available missions.",
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
                    "Simply collect as many bottles as you can before scheduling a collection.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                  const Text(
                    "After the collection, you'll receive a notification and experience points will automatically be creditted to your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.5 / 100),
                  const Text(
                    "Remember, the more you recycle at once the more experience points you'll get.",
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
        identify: "help",
        keyTarget: helpKey,
        alignSkip: Alignment.topLeft,
        // targetPosition: TargetPosition(const Size(0, 0), Offset(0, -1)),
        shape: ShapeLightFocus.Circle,
        enableOverlayTab: true,
        radius: 0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 45 / 100),
                  const Text(
                    "If you need a more in depth explanation about missions, click here!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 50 / 100),
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

    return targets;
  }
}
