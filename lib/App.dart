import 'dart:ui';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/screens/CommunityScreen.dart';
import 'package:restart/screens/HomeScreen.dart';
import 'package:restart/screens/MissionsScreen.dart';
import 'package:restart/screens/RewardScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restart/widgets/layout/Background.dart';
import 'package:restart/widgets/layout/CustomBottomNavigationBar.dart';
import 'package:restart/widgets/layout/CustomPageView.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:restart/models/PushNotification.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

GlobalKey experienceKey = GlobalKey();
GlobalKey homeForestKey = GlobalKey();
GlobalKey scheduleKey = GlobalKey();
GlobalKey profileKey = GlobalKey();
GlobalKey bottomNavigationMissionsKey = GlobalKey();

class _AppState extends State<App> {
  TxnController txnController = Get.put(TxnController());
  AuthController auth = Get.find();
  late TutorialCoachMark tutorialCoachMark;

  // ! if going from page 2 -> 0, it will prnint 2, 1, 0 since it animates through the middle page
  late PageController _pageController;
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      // _selectedIndex = index;
      auth.selectedIndex.value = index;
    });
  }

  final List<Widget> _navScreens = [
    HomeScreen(
        experienceKey: experienceKey,
        homeForestKey: homeForestKey,
        scheduleKey: scheduleKey,
        profileKey: profileKey),
    MissionsScreen(),
    const CommunityScreen(),
    // const RewardScreen(),
  ];
  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,

          extendBody: true,
          body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Tap back again to leave'),
              ),
              child: Background(
                child:
                    // color: HexColor("E2F6FF").withOpacity(0.35),
                    CustomPageView(
                  navScreens: _navScreens,
                  pageController: _pageController,
                  onPageChanged: _onPageChanged,
                ),
              )),
          bottomNavigationBar: CustomBottomNavigationBar(
            bottomNavigationMissionsKey: bottomNavigationMissionsKey,
            pageController: _pageController,
            selectedIndex: auth.selectedIndex.value,
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.blue,
      textSkip: "SKIP",
      // paddingFocus: 5,
      opacityShadow: 0.85,
      onFinish: () {
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
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "homeForest",
        keyTarget: homeForestKey,
        alignSkip: Alignment.topRight,
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
    targets.add(
      TargetFocus(
        identify: "experienceSection",
        keyTarget: experienceKey,
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
                    "Schedule a collection with us here",
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
        identify: "scheduleCard",
        keyTarget: scheduleKey,
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
                    "Schedule a collection with us here",
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
        identify: "profileSection",
        keyTarget: profileKey,
        alignSkip: Alignment.topLeft,
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
    targets.add(
      TargetFocus(
        identify: "bottomNavigationMissions",
        keyTarget: bottomNavigationMissionsKey,
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
