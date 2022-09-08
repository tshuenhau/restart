import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/GlassCard.dart';

class GlassCard_header extends StatelessWidget {
  GlassCard_header(
      {Key? key,
      required this.header,
      required this.child,
      required this.height,
      this.width})
      : super(key: key);
  Widget header;
  Widget child;
  double height;
  double? width;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      height: height,
      width: width ?? MediaQuery.of(context).size.width * 90 / 100,
      child: Column(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
                //color: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                ),
                height: MediaQuery.of(context).size.height * 8 / 100,
                width: MediaQuery.of(context).size.width * 90 / 100,
                child: Center(child: header)),
          ),
          Expanded(child: Center(child: child))
        ],
      ),
    );
  }
}
