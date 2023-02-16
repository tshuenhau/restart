import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/assets/constants.dart';

class GlassCard extends StatelessWidget {
  GlassCard(
      {Key? key,
      required this.height,
      required this.width,
      required this.child,
      this.radius})
      : super(key: key);
  double height;
  double width;
  Widget child;
  double? radius;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? DEFAULT_RADIUS),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              // ignore: prefer_const_literals_to_create_immutables
              // boxShadow: [
              //   const CustomBoxShadow(
              //       color: Colors.black,
              //       offset: Offset(-2.0, -2.0),
              //       blurRadius: 5.0,
              //       blurStyle: BlurStyle.outer)
              // ],
              borderRadius: BorderRadius.circular(radius ?? DEFAULT_RADIUS),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HexColor("D1E3FF").withOpacity(0.80),
                    HexColor("D1E3FF").withOpacity(0.45)
                  ],
                  stops: const [
                    0.0,
                    1.0
                  ]),
              // color: HexColor("D1E3FF").withOpacity(0.75),
              border: Border.all(
                strokeAlign: StrokeAlign.inside,
                width: 1,
                // color: HexColor("F2F2F2").withOpacity(0.55),
                color: HexColor("FFFFFF").withOpacity(0.75),
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.15),
              //     blurStyle: BlurStyle.outer,
              //     offset: Offset(5.0, 3.0),
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
