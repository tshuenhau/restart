import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:restart/widgets/game/Forest.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:get/get.dart';

class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    this.increase = 0,
    this.homeForestKey,
    this.experienceKey,
    Key? key,
  }) : super(key: key);

  late Key? homeForestKey;
  late Key? experienceKey;
  double increase;
  late int level;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  double carryOverExp = 0;
  bool doAnimate = false;

  UserController user = Get.find();

  void doLevelUp(double carryOverExp) async {
    setExp(0);
    await Future.delayed(const Duration(milliseconds: 100));
    // await user.updateForest();
    setExp(carryOverExp);
  }

  void setExp(double exp) {
    //TODO: this is being called twice for some reason. I think something is wrong with setting the state
    if (exp < 1) {
      setState(() {
        doAnimate = false;
      });
    } else if (exp > 0 && doAnimate == false) {
      setState(() {
        doAnimate = true;
        user.level.value++;
        user.current_points.value = carryOverExp.toInt();
      });
      carryOverExp = 0;
    }

    // setState(() {
    //   if (exp < 1) {
    //     doAnimate = false;
    //   } else if (exp > 0 && doAnimate == false) {
    //     widget.level++;
    //     doAnimate = true;
    //   }

    //   _exp = exp;
    //   carryOverExp -= exp;
    // });
  }

  @override
  void initState() {
    super.initState();
    int max = user.exp_for_level.value;

    if (mounted) {
      // if ((widget.increase + widget.current) > max) {}
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          doAnimate = !doAnimate;
          if ((widget.increase + user.current_points.value) > max) {
            user.current_points.value = max.toInt();
            //!Trigger level up. So figure out leftover exp, then pass those values to the next screen.
            print("LEVEL UP!");
            carryOverExp = widget.increase + user.current_points.value - max;
          } else {
            user.current_points.value += widget.increase.toInt();
          }
        });
      });
    }
    user.setExperienceDetails();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                          value: user.level.value,
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
                                onAnimationEnd: () {
                                  print("animation end");
                                  if (carryOverExp > 0) {
                                    print("levelling up");
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (_) => doLevelUp(carryOverExp));
                                    // doLevelUp(carryOverExp);
                                  }
                                },
                                animateFromLastPercent: true,
                                alignment: MainAxisAlignment.center,
                                animation: true,
                                lineHeight: 16,
                                animationDuration: doAnimate ? 800 : 0,
                                padding: EdgeInsets.zero,
                                percent: user.exp_for_level.value == 0
                                    ? 0
                                    : (user.current_points.value /
                                            user.exp_for_level.value)
                                        .toDouble(),
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
                        (widget.increase > 0
                            ? AnimatedFlipCounter(
                                curve: Curves.easeOut,
                                duration: Duration(milliseconds: 700),
                                value: user.current_points.value,
                              )
                            : Text(
                                user.current_points.value.toInt().toString())),
                        Text("/" + user.exp_for_level.value.toString())
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
