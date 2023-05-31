import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/screens/CommunityScreen.dart';
import 'package:restart/screens/HomeScreen.dart';
import 'package:restart/screens/MissionsScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/layout/Background.dart';
import 'package:restart/widgets/layout/CustomBottomNavigationBar.dart';
import 'package:restart/widgets/layout/CustomPageView.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final box = GetStorage();
  TxnController txnController = Get.put(TxnController());
  AuthController auth = Get.find();
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey experienceKey = GlobalKey();
  GlobalKey homeForestKey = GlobalKey();
  GlobalKey scheduleKey = GlobalKey();
  GlobalKey profileKey = GlobalKey();
  GlobalKey fullScreenKey = GlobalKey();
  GlobalKey bottomNavigationMissionsKey = GlobalKey();

  // late final ValueNotifier<bool> isOnPageTurning = ValueNotifier(false);

  // ! if going from page 2 -> 0, it will prnint 2, 1, 0 since it animates through the middle page
  late PageController _pageController;
  int _selectedIndex = 0;
  bool isOnPageTurning = false;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void scrollListener() {
    if (isOnPageTurning == true &&
        _pageController.page == _pageController.page!.roundToDouble()) {
      setState(() {
        _selectedIndex = _pageController.page!.toInt();
        isOnPageTurning = false;
        auth.selectedIndex.value =
            _selectedIndex; //! This is lagging the bottom
      });
    } else if (isOnPageTurning == false &&
        _selectedIndex.toDouble() != _pageController.page) {
      if ((_selectedIndex.toDouble() - _pageController.page!).abs() > 0.1) {
        setState(() {
          isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    // box.write("showHomeTutorial", null);
    _pageController = PageController();
    _pageController.addListener(scrollListener);

    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _navScreens = [
      HomeScreen(
          experienceKey: experienceKey,
          homeForestKey: homeForestKey,
          scheduleKey: scheduleKey,
          profileKey: profileKey),
      MissionsScreen(
          pageController: _pageController,
          isOnPageTurning: isOnPageTurning,
          fullScreenKey: fullScreenKey),
      CommunityScreen(),
      // const RewardScreen(),
    ];
    return Scaffold(
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
        fullScreenKey: fullScreenKey,
        pageController: _pageController,
        selectedIndex: _selectedIndex,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showTutorial() {
    if (box.read("showHomeTutorial") == false) {
      return;
    } else {
      if (box.read("showHomeTutorial") != true) {
        tutorialCoachMark.show(context: context);
      }

      box.write("showHomeTutorial", true);

      print("showing main tutorial");
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
        box.write("showHomeTutorial", false);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _checkPermissions();
        });
        auth.showHomeTutorial.value = false;

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
        box.write("showHomeTutorial", false);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _checkPermissions();
        });
        auth.showHomeTutorial.value = false;

        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "fullScreen",
        keyTarget: fullScreenKey,
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
                  Text(
                    "Welcome to RE:start ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 5 / 100,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 100),
                  const Text(
                    "The app that makes recycling fun, easy, and rewarding!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 100),
                  const Text(
                    "Here's how things work.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 6 / 100),
                  const Text(
                    "*Tap anywhere on the screen to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 45 / 100),
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
        enableOverlayTab: true,
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
                    "First, collected and clean the plastic (PET) bottles you want to recycle.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.55 / 100),
                  const Text(
                    "Then, schedule a collection with us here!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2.55 / 100),
                  const Text(
                    "*Please ensure that you have at least 10 bottles for us to collect.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
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
        identify: "bottomNavigationMissions",
        keyTarget: bottomNavigationMissionsKey,
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "Next, complete missions and gain experience points as you recycle.",
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
        identify: "homeForest",
        keyTarget: homeForestKey,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
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
                    "Your experience points will then go towards turning this empty land into a lush forest.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
        identify: "profileSection",
        keyTarget: profileKey,
        alignSkip: Alignment.topLeft,
        enableOverlayTab: true,
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
                    "And lastly, here's where you'll be able to edit your account details!",
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
    return targets;
  }

  _showPermissionsDialog(BuildContext context) async {
    print('showing permissions dialog!');

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: GlassCard(
              height: MediaQuery.of(context).size.height * 30 / 100,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 3 / 100,
                    vertical: MediaQuery.of(context).size.height * 2 / 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Turn on your notifications",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text(
                            "For real-time updates, exclusive offers, and personalized content!",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text("Don't worry! You will not be spammed"),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Don't Allow",
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 2 / 100,
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  PermissionStatus status =
                                      await Permission.notification.status;
                                  if (status.isPermanentlyDenied ||
                                      status.isDenied) {
                                    await openAppSettings();
                                  }
                                  status =
                                      await Permission.notification.request();

                                  print(status);

                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Allow",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _checkPermissions() async {
    var status = await Permission.notification.status;
    print(status);
    if ((status.isDenied || status.isPermanentlyDenied)) {
      if (auth.showHomeTutorial.value != null) {
        if (!auth.showHomeTutorial.value!) {
          await _showPermissionsDialog(context);
        }
        ever(auth.showHomeTutorial, (_) async {
          if (!auth.showHomeTutorial.value!) {
            await _showPermissionsDialog(context);
          }
        });
      }
    }
  }
}
