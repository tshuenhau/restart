import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class ExperienceSection extends StatefulWidget {
  ExperienceSection({
    this.increase = 0,
    required this.max,
    required this.current,
    Key? key,
  }) : super(key: key);

  final double increase;
  late double max;
  late double current;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  // AnimatedDigitController _controller = AnimatedDigitController(875);
  late double _exp = widget.current;
  double carryOverExp = 0;
  bool startAnimate = false;
  @override
  void initState() {
    super.initState();

    if ((widget.increase + widget.current) > widget.max) {}
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        startAnimate = !startAnimate;
        if ((widget.increase + widget.current) > widget.max) {
          _exp = widget
              .max; //!Trigger level up. So figure out leftover exp, then pass those values to the next screen.
          carryOverExp = widget.increase + widget.current - widget.max;
          print(carryOverExp);
        } else
          _exp += widget.increase;
      });
    });
  }

  // @override
  @override
  Widget build(BuildContext context) {
    // _controller.addValue(300);
    print("carryover: " + carryOverExp.toString());

    return SizedBox(
      height: MediaQuery.of(context).size.height * 25 / 100,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/planet_default.png",
                height: 100, width: 100),
            SizedBox(
              height: MediaQuery.of(context).size.height * 8 / 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Lvl. 17"),
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
                          // LinearPercentIndicator(
                          //     animateFromLastPercent: true,
                          //     alignment: MainAxisAlignment.center,
                          //     animation: false,
                          //     lineHeight: 16,
                          //     animationDuration: 0,
                          //     padding: EdgeInsets.zero,
                          //     percent: widget.current / widget.max,
                          //     // center: Text("80.0%"),
                          //     // barRadius: const Radius.circular(10),
                          //     progressColor: HexColor("#75AEF9"),
                          //     backgroundColor:
                          //         const Color.fromARGB(186, 255, 255, 255)
                          //             .withOpacity(0.55)),
                          (widget.increase >= 0
                              ? LinearPercentIndicator(
                                  animateFromLastPercent: true,
                                  alignment: MainAxisAlignment.center,
                                  animation: true,
                                  lineHeight: 16,
                                  animationDuration: startAnimate ? 800 : 0,
                                  padding: EdgeInsets.zero,
                                  percent: (_exp / widget.max).toDouble(),
                                  // center: Text("80.0%"),
                                  // barRadius: const Radius.circular(10),
                                  progressColor: HexColor("#75AEF9"),
                                  backgroundColor:
                                      const Color.fromARGB(186, 255, 255, 255)
                                          .withOpacity(0))
                              : Container())
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
            // ElevatedButton(
            //     onPressed: () {}, child: const Text("Continue"))
          ]),
    );
  }
}
