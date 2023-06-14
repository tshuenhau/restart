import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';

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
                child: Column(),
                height: MediaQuery.of(context).size.height * 80 / 100)
          ],
        ));
  }
}
