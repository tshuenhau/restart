import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class OpenContainerTransition extends StatelessWidget {
  OpenContainerTransition({
    required screen,
    required child,
    Key? key,
  }) : super(key: key);

  late Widget screen;
  late Widget child;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return child;
      },
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return screen;
      },
    );
  }
}
