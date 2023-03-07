import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restart/screens/AddBookingScreen.dart';
import 'package:restart/screens/ExperienceUpScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/GlassCard_1x2_Transition.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';
import 'package:animations/animations.dart';

class NextCollectionCard extends StatelessWidget {
  NextCollectionCard({Key? key, required this.isScheduled}) : super(key: key);

  bool isScheduled;

  @override
  Widget build(BuildContext context) {
    if (isScheduled) {
      return GlassCard_1x2_Transition(
          buttonText: 'Complete',
          leftChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("17 September"),
              Text("5:15pm - 5:30pm"),
            ],
          ),
          title: "Next Collection",
          navigateTo: ExperienceUpScreen());
    } else {
      return GlassCard_1x2_Transition(
          title: "Next Collection:",
          leftChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("None Scheduled"),
            ],
          ),
          buttonText: "Schedule",
          navigateTo: AddBookingScreen());
    }
  }
}
