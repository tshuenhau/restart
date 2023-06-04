import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/widgets/game/Forest.dart';

class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    this.homeForestKey,
    this.experienceKey,
    Key? key,
  }) : super(key: key);

  late Key? homeForestKey;
  late Key? experienceKey;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  bool doAnimate = false;
  late double _exp = current;
  late int level;
  late double current;
  late double increase;
  bool levelUp = false;
  UserController user = Get.find();
  AuthController auth = Get.find();
  double carryOverExp = 0;
  double max = 0;

  @override
  void initState() {
    super.initState();
    updateExp();
  }

  void updateExp() {
    //!lets play with the auth.user.value!.level

    print("levellin?:" + user.isLevelUp.value.toString());
    doAnimate = true;
    increase = user.increase.value.toDouble();
    user.increase.value = 0;
    max = auth.user.value!.exp_for_level.toDouble();
    _exp = auth.user.value!.current_points.toDouble();

    if (increase + _exp > max) {
      //!User leveled up
      doAnimate = true;
      Future.delayed(Duration(milliseconds: 1200));
      carryOverExp = increase + _exp - max;
      _exp = max;
      // user.;
      // doAnimate = false;

      // print("exp: " + _exp.toString());
      // print("increase: " + increase.toString());
      // print("max: " + max.toString());
      // print("carryoverexp: " + carryOverExp.toString());
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    print("levellin?:" + user.isLevelUp.value.toString());

    //!Check for carryoverexp here and set user.increase.value = carryoverexp
    updateExp();
    return Obx(() {
      print("levellin? in build:" + user.isLevelUp.value.toString());

      return SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset("assets/images/sprites/forest/forest_placeholder3.png",
              //     height: 200, width: 200),
              SizedBox(key: widget.homeForestKey, child: Forest()),
              SizedBox(
                key: widget.experienceKey,
                height: MediaQuery.of(context).size.height * 8 / 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Lvl. "),
                        AnimatedFlipCounter(
                          curve: Curves.easeOut,
                          duration: Duration(milliseconds: 700),
                          value: auth.user.value!.level,
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 60 / 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 99, 99, 99),
                            width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff317ab),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            LinearPercentIndicator(
                                onAnimationEnd: () async {
                                  // if (_exp >= max) {
                                  //   WidgetsBinding.instance
                                  //       .addPostFrameCallback(
                                  //           (_) => doLevelUp(increase));
                                  // }

                                  // doLevelUp(carryOverExp);
                                  // }

                                  updateExp();
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));

                                  if (carryOverExp > 0) {
                                    user.increase.value = carryOverExp.toInt();
                                  } else {
                                    user.increase.value = 0;
                                  }
                                  carryOverExp = 0;
                                  doAnimate = false;

                                  print("userincreasevlaue: " +
                                      user.increase.value.toString());
                                  print("carryoverexp: " +
                                      carryOverExp.toString());
                                  // init();
                                },
                                animateFromLastPercent: true,
                                alignment: MainAxisAlignment.center,
                                animation: true,
                                lineHeight: 16,
                                animationDuration: doAnimate ? 800 : 0,
                                padding: EdgeInsets.zero,
                                percent: _exp / max,
                                progressColor: HexColor("#75AEF9"),
                                backgroundColor:
                                    const Color.fromARGB(186, 255, 255, 255)
                                        .withOpacity(0.3))
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (AnimatedFlipCounter(
                          curve: Curves.easeOut,
                          duration: Duration(milliseconds: 700),
                          value: _exp,
                        )),
                        const Text("/"),
                        AnimatedFlipCounter(
                          curve: Curves.easeOut,
                          duration: Duration(milliseconds: 700),
                          value: auth.user.value!.exp_for_level,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ]),
      );
    });
  }
}
