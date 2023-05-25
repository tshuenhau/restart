import 'package:flutter/material.dart';
import 'package:restart/models/MissionModel.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';

import '../widgets/Glasscards/GlassCard_header.dart';

class ExperienceUpScreen extends StatefulWidget {
  ExperienceUpScreen({
    required this.mission,
    required this.overflow,
    Key? key,
  }) : super(key: key);
  bool _visible = false;
  // bool newExpBar = false;
  MissionModel mission;
  late double overflow;

  @override
  State<ExperienceUpScreen> createState() => _ExperienceUpScreenState();
}

class _ExperienceUpScreenState extends State<ExperienceUpScreen> {
  late bool isLevelUp;
  bool canContinue = false;

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    // .toDouble();
    // print(overflow);
    isLevelUp = widget.overflow >= 0;
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        if (isLevelUp) {
          setState(() {
            widget._visible = true;
            canContinue = true;
            // user.current_points.value = 0;
          });
        } else {
          setState(() {
            canContinue = true;
          });
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          // widget.newExpBar = true;
        });
      }
    });
  }

  @override
  void dispose() {
    //...
    super.dispose();
    widget._visible = false;
    // widget.newExpBar = false;

    //...
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      GlassCard_header(
          key: const ValueKey(2),
          header: Header(title: widget.mission.title),
          height: MediaQuery.of(context).size.height * 90 / 100,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 45 / 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("+" + widget.mission.exp.toInt().toString() + " points"),
                ExperienceSection(
                  // key: const Key('forest'),
                  experienceKey: GlobalKey(),
                  homeForestKey: GlobalKey(),
                ),
                AnimatedOpacity(
                    opacity: widget._visible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    child: Text("LEVEL UP!")),
                ElevatedButton(
                    onPressed: canContinue
                        ? () {
                            if (isLevelUp) {
                              pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.decelerate);
                            } else {
                              Navigator.of(context).pop(this);
                            }
                          }
                        : null,
                    child: Text("Continue"))
              ],
            ),
          )),
      GlassCard_header(
          //TODO: Extract out to LevelUp
          key: ValueKey(1),
          header: Header(title: "LEVEL UP"),
          height: MediaQuery.of(context).size.height * 90 / 100,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 45 / 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("+" + widget.overflow.toInt().toString() + " points"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(this);
                    },
                    child: Text("Continue"))
              ],
            ),
          )),
    ];
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: CustomScaffold(
            body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: screens,
        )));
  }
}
