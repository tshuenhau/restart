import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ExperienceSection extends StatelessWidget {
  ExperienceSection({
    required this.isIncrease,
    Key? key,
  }) : super(key: key);

  late bool isIncrease;
  AnimatedDigitController _controller = AnimatedDigitController(875);

  // @override
  // void initState() {
  //   _controller.addValue(300);
  // }

  @override
  Widget build(BuildContext context) {
    _controller.addValue(300);

    // Future.delayed(const Duration(milliseconds: 500), () {
    // });
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
                          LinearPercentIndicator(
                              animateFromLastPercent: true,
                              alignment: MainAxisAlignment.center,
                              animation: false,
                              lineHeight: 16,
                              animationDuration: 800,
                              padding: EdgeInsets.zero,
                              percent: 875 / 1200,
                              // center: Text("80.0%"),
                              // barRadius: const Radius.circular(10),
                              progressColor: HexColor("#75AEF9"),
                              backgroundColor:
                                  const Color.fromARGB(186, 255, 255, 255)
                                      .withOpacity(0.55)),
                          (isIncrease
                              ? LinearPercentIndicator(
                                  alignment: MainAxisAlignment.center,
                                  animation: true,
                                  lineHeight: 16,
                                  animationDuration: 800,
                                  padding: EdgeInsets.zero,
                                  percent: 1150 / 1200,
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
                      (isIncrease
                          ? AnimatedDigitWidget(
                              duration: Duration(milliseconds: 1000),
                              controller: _controller,
                              textStyle: TextStyle(color: Colors.black),
                              fractionDigits:
                                  0, // number of decimal places reserved, not rounded
                              enableSeparator: true, // like this 10,240.98
                            )
                          : Text("875")),
                      Text("/1200")
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
