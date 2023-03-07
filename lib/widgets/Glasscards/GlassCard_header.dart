import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';

import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/Glasscards/Header.dart';

class GlassCard_header extends StatelessWidget {
  GlassCard_header(
      {Key? key,
      required this.header,
      required this.child,
      required this.height,
      this.width,
      this.radius})
      : super(key: key);
  Header header;
  Widget child;
  double height;
  double? width;
  double? radius;

  @override
  Widget build(BuildContext context) {
    double headerHeight = MediaQuery.of(context).size.height * 8 / 100;

    return SizedBox(
      height: height,
      child: Stack(alignment: Alignment.topCenter, children: [
        GlassCard(
            height: height,
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
                strokeAlign: BorderSide.strokeAlignInside,
                width: 0,
                // color: HexColor("F2F2F2").withOpacity(0.55),
                color: HexColor("FFFFFF").withOpacity(0.55),
              ),
              color: Colors.white.withOpacity(0.9),
            ),
            height: headerHeight,
            width: width ?? MediaQuery.of(context).size.width * 90 / 100,
            child: Center(child: header)),
      ]),
    );
  }
}
