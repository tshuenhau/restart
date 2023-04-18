import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    this.increase = 0,
    required this.current,
    required this.level,
    Key? key,
  }) : super(key: key);

  double increase;
  late double current;
  late int level;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  late double _exp = widget.current;
  double carryOverExp = 0;
  bool doAnimate = false;
  late int level = widget.level;
  late int max = level * 50;

  void doLevelUp(double carryOverExp) async {
    setExp(0);
    await Future.delayed(const Duration(milliseconds: 100));
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
        level++;
        doAnimate = true;
        _exp = carryOverExp;
        carryOverExp = 0;
      });
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
    if (mounted) {
      // if ((widget.increase + widget.current) > max) {}
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          doAnimate = !doAnimate;
          if ((widget.increase + widget.current) > max) {
            _exp = max
                .toDouble(); //!Trigger level up. So figure out leftover exp, then pass those values to the next screen.
            carryOverExp = widget.increase + widget.current - max;
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
    print('max ' + max.toString());
    print('level ' + level.toString());
    print('exp ' + _exp.toString());
    print('exp ' + widget.current.toString());
    return SizedBox(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/sprites/forest/forest_placeholder3.png",
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
                          : Text(_exp.toInt().toString())),
                      Text("/" + max.toInt().toString())
                    ],
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
