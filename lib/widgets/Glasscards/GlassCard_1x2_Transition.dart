import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restart/screens/AddBookingScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';

class GlassCard_1x2_Transition extends StatelessWidget {
  GlassCard_1x2_Transition({
    required this.title,
    required this.leftChild,
    required this.buttonText,
    required this.navigateTo,
    Key? key,
  }) : super(key: key);

  late String title;
  late Widget leftChild;
  late String buttonText;
  late Widget navigateTo;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: false,
      closedElevation: 0,
      openElevation: 0,
      middleColor: Colors.transparent,
      closedColor: Colors.transparent,
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return GlassCard_1x2(
            title: title,
            leftChild: leftChild,
            rightChild: ElevatedButton(
              onPressed: openContainer,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      16 /
                      100, //!Bug here, need to check if mounted
                  child: AutoSizeText(
                    buttonText,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  )),
            ));
        ;
      },
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return navigateTo;
      },
    );
  }
}
