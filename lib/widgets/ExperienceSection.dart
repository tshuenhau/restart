import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/AuthController.dart';

class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    this.increase = 0,
    // required this.current,
    // required this.level,
    Key? key,
  }) : super(key: key);

  double increase;
  // late double current;
  // int level;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  AuthController auth = Get.find();
  double carryOverExp = 0;
  bool doAnimate = false;

  Future<void> doLevelUp(double carryOverExp) async {
    setExp(0);
    await Future.delayed(const Duration(milliseconds: 100));
    print("carry over exp " + carryOverExp.toString());
    setExp(carryOverExp);
  }

  void setExp(double exp) {
    //TODO: this is being called twice for some reason. I think something is wrong with setting the state
    print('exp: ' + exp.toString());
    if (exp < 1) {
      setState(() {
        doAnimate = false;
      });
    } else if ((exp > 0 && doAnimate == false)) {
      auth.user.value!.level++;
      auth.user.value!.current_points = carryOverExp.toInt();
      setState(() {
        doAnimate = true;
      });
    }
    print('current points ' + auth.user.value!.current_points.toString());
  }

  @override
  void initState() {
    int max = (auth.user.value!.level * 50); //TO FIX: MAGIC NUMBER
    if (mounted) {
      // if ((widget.increase + auth.user.value!.current_points) > max) {}
      Future.delayed(const Duration(milliseconds: 500), () async {
        setState(() {
          doAnimate = !doAnimate;

          if ((widget.increase + auth.user.value!.current_points) > max) {
            auth.user.value!.current_points = max
                .toInt(); //!Trigger level up. So figure out leftover exp, then pass those values to the next screen.
            carryOverExp =
                widget.increase + auth.user.value!.current_points - max;
            doLevelUp(carryOverExp);
            auth.user.value!.level++;
          } else {
            auth.user.value!.current_points += widget.increase.toInt();
          }
        });
      });
    }
    super.initState();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                  "assets/images/sprites/forest/forest_placeholder3.png",
                  height: 200,
                  width: 200),
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
                                  if (carryOverExp > 0) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (_) => doLevelUp(carryOverExp));
                                  }
                                },
                                animateFromLastPercent: true,
                                alignment: MainAxisAlignment.center,
                                animation: true,
                                lineHeight: 16,
                                animationDuration: doAnimate ? 800 : 0,
                                padding: EdgeInsets.zero,
                                percent: (auth.user.value!.current_points /
                                    (auth.user.value!.level * 50).toDouble()),
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
                                duration: const Duration(milliseconds: 700),
                                value:
                                    auth.user.value!.current_points.toDouble(),
                              )
                            : Text(auth.user.value!.current_points.toString())),
                        Text("/" +
                            (auth.user.value!.level * 50).toInt().toString())
                      ],
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
