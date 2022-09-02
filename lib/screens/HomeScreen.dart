import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/CustomBoxShadow.dart';
import 'package:restart/widgets/GlassCard.dart';
import 'package:restart/widgets/GlassCard_1x2.dart';
import 'package:restart/widgets/GlassCard_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          GlassCard(
            radius: 20,
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
                      child: Center(child: Text("Titile"))),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
          GlassCard_1x2(
              title: "Titile",
              leftChild: Text("Left"),
              rightChild: Text("right")),
          SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
          GlassCard_header(
              header: Text("HEADER"),
              child: Column(children: [Text("Hello"), Text("Hello")])),
        ],
      ),
    );
  }
}
