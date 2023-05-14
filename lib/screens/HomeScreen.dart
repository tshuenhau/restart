import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/NextCollectionCard.dart';
import 'package:restart/widgets/PastCollectionCard.dart';
import 'package:restart/widgets/ProfileCard.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(
      {Key? key,
      required this.experienceKey,
      required this.homeForestKey,
      required this.scheduleKey,
      required this.profileKey})
      : super(key: key);

  late Key experienceKey;
  late Key homeForestKey;
  late Key scheduleKey;
  late Key profileKey;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TutorialCoachMark tutorialCoachMark;

  // GlobalKey experienceKey = GlobalKey();
  // GlobalKey homeForestKey = GlobalKey();
  // GlobalKey scheduleKey = GlobalKey();
  // GlobalKey profileKey = GlobalKey();

  // @override
  // void initState() {
  //   createTutorial();
  //   Future.delayed(Duration.zero, showTutorial);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    TxnController txnController = Get.find();
    AuthController auth = Get.find();
    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

    return Obx(() => SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 1.5 / 100,
                bottom: MediaQuery.of(context).size.height * 3 / 100),
            shrinkWrap: true,
            children: [
              ProfileCard(
                  homeForestKey: widget.homeForestKey,
                  experienceKey: widget.experienceKey,
                  profileKey: widget.profileKey),
              verticalSpacing,
              txnController.upcomingTxns.isEmpty &&
                      txnController.hasInitialised.value
                  ? verticalSpacing
                  : txnController.upcomingTxns.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return Column(children: [
                              NextCollectionCard(isScheduled: true, i: i),
                              verticalSpacing,
                            ]);
                          },
                          itemCount: txnController.upcomingTxns.length,
                        )
                      : verticalSpacing,
              SizedBox(
                  key: widget.scheduleKey,
                  child: NextCollectionCard(isScheduled: false, i: null)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Column(children: [
                    PastCollectionCard(i: i),
                    verticalSpacing,
                  ]);
                },
                itemCount: txnController.completedTxns.length,
              ),
              // Column(
              //   children: [
              //     PastCollectionCard(date: DateTime.now(), points: 65),
              //     verticalSpacing,
              //     PastCollectionCard(date: DateTime.now(), points: 65),
              //     verticalSpacing,
              //     PastCollectionCard(date: DateTime.now(), points: 65),
              //     verticalSpacing,
              //   ],
              // ),
            ],
          ),
        ));
  }

  // void showTutorial() {
  //   tutorialCoachMark.show(context: context);
  // }

  // void createTutorial() {
  //   tutorialCoachMark = TutorialCoachMark(
  //     targets: _createTargets(),
  //     colorShadow: Colors.blue,
  //     textSkip: "SKIP",
  //     // paddingFocus: 5,
  //     opacityShadow: 0.85,
  //     onFinish: () {
  //       print("finish");
  //     },
  //     onClickTarget: (target) {
  //       print('onClickTarget: $target');
  //     },
  //     onClickTargetWithTapPosition: (target, tapDetails) {
  //       print("target: $target");
  //       print(
  //           "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
  //     },
  //     onClickOverlay: (target) {
  //       print('onClickOverlay: $target');
  //     },
  //     onSkip: () {
  //       print("skip");
  //     },
  //   );
  // }

  // List<TargetFocus> _createTargets() {
  //   List<TargetFocus> targets = [];
  //   targets.add(
  //     TargetFocus(
  //       identify: "homeForest",
  //       keyTarget: homeForestKey,
  //       alignSkip: Alignment.topRight,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.bottom,
  //           builder: (context, controller) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                     height: MediaQuery.of(context).size.height * 2.55 / 100),
  //                 const Text(
  //                   "Here's your forest.",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.bold),
  //                 ),
  //                 SizedBox(
  //                     height: MediaQuery.of(context).size.height * 1 / 100),
  //                 const Text(
  //                   "It might be empty now, but recycle with us and soon it'll into turn a lush green forest!",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                   ),
  //                 )
  //               ],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "experienceSection",
  //       keyTarget: experienceKey,
  //       alignSkip: Alignment.topRight,
  //       shape: ShapeLightFocus.RRect,
  //       radius: DEFAULT_RADIUS,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.top,
  //           builder: (context, controller) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                     height: MediaQuery.of(context).size.height * 2.55 / 100),
  //                 const Text(
  //                   "Schedule a collection with us here",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.bold),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "scheduleCard",
  //       keyTarget: scheduleKey,
  //       alignSkip: Alignment.topRight,
  //       shape: ShapeLightFocus.RRect,
  //       radius: DEFAULT_RADIUS,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.top,
  //           builder: (context, controller) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                     height: MediaQuery.of(context).size.height * 2.55 / 100),
  //                 const Text(
  //                   "Schedule a collection with us here",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.bold),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //   targets.add(
  //     TargetFocus(
  //       identify: "profileSection",
  //       keyTarget: profileKey,
  //       alignSkip: Alignment.topLeft,
  //       contents: [
  //         TargetContent(
  //           align: ContentAlign.bottom,
  //           builder: (context, controller) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SizedBox(
  //                     height: MediaQuery.of(context).size.height * 2.55 / 100),
  //                 const Text(
  //                   "Here's your forest.",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.bold),
  //                 ),
  //                 SizedBox(
  //                     height: MediaQuery.of(context).size.height * 1 / 100),
  //                 const Text(
  //                   "It might be empty now, but recycle with us and soon it'll into turn a lush green forest!",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                   ),
  //                 )
  //               ],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );

  //   return targets;
  // }
}
