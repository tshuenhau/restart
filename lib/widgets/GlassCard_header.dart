import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/GlassCard.dart';

class GlassCard_header extends StatelessWidget {
  GlassCard_header({Key? key, required this.header, required Widget this.child})
      : super(key: key);
  Widget header;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 20,
      height: MediaQuery.of(context).size.height * 50 / 100,
      width: MediaQuery.of(context).size.width * 90 / 100,
      child: Column(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
                //color: Colors.white,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
                height: MediaQuery.of(context).size.height * 8 / 100,
                width: MediaQuery.of(context).size.width * 90 / 100,
                child: Center(child: header)),
          ),
          child
        ],
      ),
    );
  }
}
