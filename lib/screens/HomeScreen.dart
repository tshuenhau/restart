import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restart/screens/AddBookingScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

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
              height: MediaQuery.of(context).size.height * 38 / 100,
              child: ExperienceSection()),
          verticalSpacing,
          GlassCard_1x2(
              title: "Next Collection:",
              leftChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("17 September"),
                  Text("5:15pm - 5:30pm"),
                ],
              ),
              rightChild: ElevatedButton(
                onPressed: () {},
                child: Text("Complete"),
              )),
          verticalSpacing,
          GlassCard_1x2(
              title: "Next Collection:",
              leftChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("None Scheduled"),
                ],
              ),
              rightChild: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddBookingScreen()));
                },
                child: Text("Schedule"),
              )),
          verticalSpacing,
          GlassCard_header(
              header: const Text("Name"),
              height: MediaQuery.of(context).size.height * 60 / 100,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 45 / 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("+75 points"),
                    ExperienceSection(),
                    Text("LEVEL UP"),
                    ElevatedButton(onPressed: () {}, child: Text("Continue"))
                  ],
                ),
              )),
          verticalSpacing,
          GlassCard_1x2(
              title: "TiTle",
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
