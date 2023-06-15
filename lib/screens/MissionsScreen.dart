import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/mission/MissionCard.dart';

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
                                MediaQuery.of(context).size.width * 2 / 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                          color: Colors.white.withOpacity(0.72),
                        ),
                        height: MediaQuery.of(context).size.height * 12 / 100,
                        child: Center(
                          child: Text(
                              "Complete missions by recycling the stated weight in a single collection.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        )),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  MissionCard(
                    weight: 0.5,
                    exp: 10,
                    pageController: widget.pageController,
                  ),
                  MissionCard(
                    weight: 1,
                    exp: 10,
                    pageController: widget.pageController,
                  ),
                  MissionCard(
                    weight: 1.5,
                    exp: 30,
                    pageController: widget.pageController,
                  ),
                  MissionCard(
                    weight: 2.5,
                    exp: 50,
                    pageController: widget.pageController,
                  ),
                  MissionCard(
                    weight: 3,
                    exp: 100,
                    pageController: widget.pageController,
                  ),
                  MissionCard(
                    weight: 3.5,
                    exp: 180,
                    pageController: widget.pageController,
                  )
                ]),
                height: MediaQuery.of(context).size.height * 80 / 100)
          ],
        ));
  }
}
