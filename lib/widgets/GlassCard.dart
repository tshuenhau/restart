import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/CustomBoxShadow.dart';

class GlassCard extends StatelessWidget {
  GlassCard(
      {Key? key,
      required this.height,
      required this.width,
      required this.child,
      required this.radius})
      : super(key: key);
  double height;
  double width;
  Widget child;
  double radius;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
        child: Container(
            decoration: BoxDecoration(
              color: HexColor("D1E3FF").withOpacity(0.55),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                width: 1,
                color: HexColor("F2F2F2").withOpacity(0.55),
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.15),
              //     blurStyle: BlurStyle.outer,
              //     offset: Offset(-3.0, -3.0),
              //     blurRadius: 1.0,
              //   )
              // ]
            ),
            height: height,
            width: width,
            child: SizedBox(child: child)),
      ),
    ));
  }
}
