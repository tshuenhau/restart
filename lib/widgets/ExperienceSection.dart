import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';

class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    this.increase = 0,
    this.homeForestKey,
    this.experienceKey,
    Key? key,
  }) : super(key: key);

  double increase;
  late Key? homeForestKey;
  late Key? experienceKey;
  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  late double max;
  late double current;
  late int level;
  UserController user = Get.find();
  AuthController auth = Get.find();

  late double _exp = current;
  double carryOverExp = 0;
  bool doAnimate = false;

  void doLevelUp(double carryOverExp) async {
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
        level += 1;
        auth.user.value!.level += 1;
        max = auth.user.value!.exp_for_level.toDouble();
        doAnimate = true;
      }
      _exp = exp;
      carryOverExp -= exp;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      level = auth.user.value!.level;
      current = auth.user.value!.current_points.toDouble();
      max = auth.user.value!.exp_for_level.toDouble();
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          doAnimate = !doAnimate;
          if ((widget.increase + current) >= max) {
            _exp =
                max; //!Trigger level up. So figure out leftover exp, then pass those values to the next screen.
            carryOverExp = widget.increase + current - max;
            print("carryover: " + carryOverExp.toString());
          } else {
            _exp += widget.increase;
          }
        });
      });
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/sprites/forest/forestlandnew.png",
                height: 200, width: 200),
            SizedBox(
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
                        value: level,
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
                                if (carryOverExp > 0 || _exp == max) {
                                  WidgetsBinding.instance.addPostFrameCallback(
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
                              percent: (_exp / max).toDouble(),
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
                              value: _exp,
                            )
                          : Text(current.toInt().toString())),
                      const Text("/"),
                      AnimatedFlipCounter(
                        curve: Curves.easeOut,
                        duration: Duration(milliseconds: 700),
                        value: max.toInt(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
