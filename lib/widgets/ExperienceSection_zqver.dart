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
  bool doAnimate = false;
  double _exp = 0;

  UserController user = Get.find();
  AuthController auth = Get.find();
  double carryOverExp = 0;
  double max = 0;
  double prev_max = 0;

  void doLevelUp(double exp_for_level, double carryOverExp) async {
    setExp(exp_for_level);
    await Future.delayed(const Duration(milliseconds: 100));
    setExp(0);
    await Future.delayed(const Duration(milliseconds: 100));
    setExp(carryOverExp);
  }

  void setExp(double exp) {
    //TODO: this is being called twice for some reason. I think something is wrong with setting the state
    setState(() {
      if (exp < 1) {
        doAnimate = false;
      } else if (exp > 0 && doAnimate == false) {
        prev_max = auth.user.value!.level.toDouble();
        auth.user.value!.level += 1;
        doAnimate = true;
      }
      print("_exp is changed here");
      _exp = exp;
      carryOverExp -= exp;
    });
  }

  void init() {
    int max = auth.user.value!.exp_for_level;
    _exp = auth.user.value!.current_points.toDouble();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        doAnimate = !doAnimate;
        if ((widget.increase + auth.user.value!.current_points) >= max) {
          _exp = max
              .toDouble(); //!Trigger level up. So figure out leftover exp, then pass those values to the next screen.
          carryOverExp =
              widget.increase + auth.user.value!.current_points - max;
        } else {
          _exp += widget.increase;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    doAnimate = true;
    init();
    // user.setExperienceDetails();
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
                                onAnimationEnd: () {
                                  print("animation end");
                                  print('carry over exp ' +
                                      carryOverExp.toString());
                                  // if (carryOverExp > 0) {
                                  print("levelling up");

                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => doLevelUp(prev_max, carryOverExp));
                                  // doLevelUp(carryOverExp);
                                  // }
                                  init();
                                },
                                animateFromLastPercent: true,
                                alignment: MainAxisAlignment.center,
                                animation: true,
                                lineHeight: 16,
                                animationDuration: doAnimate ? 800 : 0,
                                padding: EdgeInsets.zero,
                                percent: auth.user.value!.exp_for_level == 0
                                    ? 0
                                    : (auth.user.value!.current_points /
                                            auth.user.value!.exp_for_level)
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
                                value: auth.user.value!.current_points,
                              )
                            : Text(auth.user.value!.current_points
                                .toInt()
                                .toString())),
                        Text("/" + auth.user.value!.exp_for_level.toString())
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
