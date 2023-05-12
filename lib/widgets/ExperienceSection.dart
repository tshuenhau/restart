import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:restart/widgets/game/Forest.dart';

class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    this.increase = 0,
    required this.max,
    required this.current,
    required this.homeForestKey,
    required this.experienceKey,
    Key? key,
  }) : super(key: key);

  late Key homeForestKey;
  late Key experienceKey;
  double increase;
  late double max;
  late double current;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  int level = 17;

  late double _exp = widget.current;
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
      if ((widget.increase + widget.current) > widget.max) {}
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          doAnimate = !doAnimate;
          if ((widget.increase + widget.current) > widget.max) {
            _exp = widget
                .max; //!Trigger level up. So figure out leftover exp, then pass those values to the next screen.
            carryOverExp = widget.increase + widget.current - widget.max;
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
                                if (carryOverExp > 0) {
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
                              percent: (_exp / widget.max).toDouble(),
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
                          : Text(widget.current.toInt().toString())),
                      Text("/" + widget.max.toInt().toString())
                    ],
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
