import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/CustomBoxShadow.dart';
import 'package:restart/widgets/GlassCard.dart';
import 'package:restart/widgets/GlassCard_1x2.dart';
import 'package:restart/widgets/GlassCard_header.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 1.5 / 100,
            bottom: MediaQuery.of(context).size.height * 3 / 100),
        children: [
          GlassCard_header(
              header: const Text("Name"),
              height: MediaQuery.of(context).size.height * 45 / 100,
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
                              child: LinearPercentIndicator(
                                  alignment: MainAxisAlignment.center,
                                  animation: true,
                                  lineHeight: 16,
                                  animationDuration: 800,
                                  padding: EdgeInsets.zero,
                                  percent: 875 / 1200,
                                  // center: Text("80.0%"),
                                  // barRadius: const Radius.circular(10),
                                  progressColor: HexColor("#75AEF9"),
                                  backgroundColor:
                                      const Color.fromARGB(186, 255, 255, 255)),
                            ),
                          ),
                          Text("875/1,200"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Continue"))
                  ])),
          SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
          GlassCard_1x2(
              title: "Titile",
              leftChild: const Text("Left"),
              rightChild: const Text("right")),
          SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
          GlassCard(
            height: MediaQuery.of(context).size.height * 38 / 100,
            width: MediaQuery.of(context).size.width * 90 / 100,
            child: Column(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                  child: Container(
                      //color: Colors.white,
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.9)),
                      height: MediaQuery.of(context).size.height * 8 / 100,
                      width: MediaQuery.of(context).size.width * 90 / 100,
                      child: const Center(child: const Text("Titile"))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
