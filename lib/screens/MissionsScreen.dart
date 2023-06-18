import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/MissionCard.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/MissionController.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAnalytics.instance.setCurrentScreen(
        screenName: 'Missions Screen',
        screenClassOverride: 'Screens',
      );
    });
  }

  MissionController missionController = Get.put(MissionController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.5 / 100,
              bottom: MediaQuery.of(context).size.height * 3 / 100),
          children: [
            GlassCard_header(
                header: Header(title: "Missions"),
                child: ListView(children: [
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
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return MissionCard(
                        weight: missionController.missions[i].weight,
                        exp: missionController.missions[i].exp,
                      );
                    },
                    itemCount: missionController.missions.length,
                  ))
                ]),
                height: MediaQuery.of(context).size.height * 85 / 100)
          ],
        ));
  }
}
