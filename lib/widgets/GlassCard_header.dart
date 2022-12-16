import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/GlassCard.dart';

import 'package:restart/assets/constants.dart';

class GlassCard_header extends StatelessWidget {
  GlassCard_header(
      {Key? key,
      required this.header,
      required this.child,
      required this.height,
      this.width,
      this.radius})
      : super(key: key);
  Widget header;
  Widget child;
  double height;
  double? width;
  double? radius;

  @override
  Widget build(BuildContext context) {
    double headerHeight = MediaQuery.of(context).size.height * 8 / 100;

    return Stack(alignment: Alignment.topCenter, children: [
      GlassCard(
          height: height,
          width: width ?? MediaQuery.of(context).size.width * 90 / 100,
          child: Container(
              padding: EdgeInsets.only(top: headerHeight), child: child)),
      Container(
          //color: Colors.white,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius ?? DEFAULT_RADIUS),
              topRight: Radius.circular(radius ?? DEFAULT_RADIUS),
            ),
            border: Border.all(
              strokeAlign: StrokeAlign.inside,
              width: 0,
              // color: HexColor("F2F2F2").withOpacity(0.55),
              color: HexColor("FFFFFF").withOpacity(0.55),
            ),
            color: Colors.white.withOpacity(0.9),
          ),
          height: headerHeight,
          width: width ?? MediaQuery.of(context).size.width * 90 / 100,
          child: Center(child: header)),
    ]);

    // return GlassCard(
    //   height: height,
    //   width: width ?? MediaQuery.of(context).size.width * 90 / 100,
    //   child: Column(
    //     children: [
    //       BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
    //         child: Container(
    //             //color: Colors.white,
    //             decoration: BoxDecoration(
    //               color: Colors.white.withOpacity(0.9),
    //             ),
    //             height: MediaQuery.of(context).size.height * 8 / 100,
    //             width: MediaQuery.of(context).size.width * 90 / 100,
    //             child: Center(child: header)),
    //       ),
    //       Expanded(child: Center(child: child))
    //     ],
    //   ),
    // );
  }
}
