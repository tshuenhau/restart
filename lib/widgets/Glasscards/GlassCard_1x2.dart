import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';

class GlassCard_1x2 extends StatelessWidget {
  GlassCard_1x2(
      {Key? key,
      required this.leftChild,
      required this.rightChild,
      required this.title})
      : super(key: key);

  Widget leftChild;
  Widget rightChild;
  String title;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
        radius: 10,
        height: MediaQuery.of(context).size.height * 18 / 100,
        child: Stack(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 4 / 100,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 4 / 100),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: AutoSizeText(title, maxLines: 1),
                  ),
                )),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height * 15 / 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 40 / 100,
                        child: Center(child: leftChild)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 11 / 100,
                      child: VerticalDivider(
                          color: HexColor("AAAAAA").withOpacity(0.35),
                          // color: HexColor("FFFFFF").withOpacity(0.55),

                          thickness: 2),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 40 / 100,
                        child: Center(child: rightChild))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
