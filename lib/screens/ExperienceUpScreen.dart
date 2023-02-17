import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:restart/screens/CustomScaffold.dart';
import 'package:restart/screens/LevelUpScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import '../widgets/Glasscards/GlassCard_header.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ExperienceUpScreen extends StatefulWidget {
  ExperienceUpScreen({Key? key}) : super(key: key);
  bool _visible = false;
  bool newExpBar = false;

  @override
  State<ExperienceUpScreen> createState() => _ExperienceUpScreenState();
}

class _ExperienceUpScreenState extends State<ExperienceUpScreen> {
  double increase = 400;
  double current = 875;
  double max = 1200;
  late double overflow;
  late bool isLevelUp;
  bool canContinue = false;

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    overflow = increase + current - max;
    isLevelUp = (overflow >= 0 ? true : false);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        if (isLevelUp) {
          setState(() {
            widget._visible = true;
            canContinue = true;
            current = 0;
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
          widget.newExpBar = true;
        });
      }
    });
  }

  @override
  void dispose() {
    //...
    super.dispose();
    widget._visible = false;
    widget.newExpBar = false;

    //...
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      GlassCard_header(
          key: ValueKey(2),
          header: Header(title: "Name"),
          height: MediaQuery.of(context).size.height * 90 / 100,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 45 / 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("+" + increase.toInt().toString() + " points"),

                ExperienceSection(
                    key: ValueKey(2),
                    current: current,
                    max: max,
                    increase: increase
                    // - (isLevelUp ? overflow : 0)
                    ),
                AnimatedOpacity(
                    opacity: widget._visible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    child: Text("LEVEL UP!")),
                // Text("LEVEL UP"),
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
                Text("+" + overflow.toInt().toString() + " points"),
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
      )),
    );
  }
}
