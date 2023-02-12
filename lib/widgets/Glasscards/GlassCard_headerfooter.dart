import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';

class GlassCard_headerfooter extends StatelessWidget {
  GlassCard_headerfooter(
      {Key? key,
      required this.header,
      required this.footer,
      required this.body,
      required this.height})
      : super(key: key);
  Header header;
  Widget footer;
  Widget body;
  double height;

  @override
  Widget build(BuildContext context) {
    return GlassCard_header(
        header: header,
        child: Column(
          children: [
            Expanded(child: body),
            Container(
              color: Colors.white.withOpacity(0.9),
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 1.5 / 100,
                      bottom: MediaQuery.of(context).size.height * 1.5 / 100),
                  child: footer),
            )
          ],
        ),
        height: height);
  }
}
