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
      // return GlassCard_1x2(
      //     title: "Next Collection:",
      //     leftChild: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Text("17 September"),
      //         Text("5:15pm - 5:30pm"),
      //       ],
      //     ),
      //     rightChild: ElevatedButton(
      //       onPressed: () => Dialogs.materialDialog(
      //           msg: 'Are you sure ?',
      //           title: "Confirm Pickup",
      //           color: Colors.white,
      //           context: context,
      //           actions: [
      //             IconsOutlineButton(
      //               onPressed: () {
      //                 Navigator.of(context).pop(this);
      //               },
      //               text: 'Cancel',
      //               iconData: Icons.cancel_outlined,
      //               textStyle: TextStyle(color: Colors.grey),
      //               iconColor: Colors.grey,
      //             ),
      //             IconsButton(
      //               onPressed: () {
      //                 // Navigator.push(
      //                 //     context,
      //                 //     PageTransition(
      //                 //       type: PageTransitionType.fade,
      //                 //       // alignment: Alignment.center,
      //                 //       child: ExperienceSection(),
      //                 //       // childCurrent: this
      //                 //     ));
      //               },
      //               text: 'Confirm',
      //               iconData: Icons.delete,
      //               color: Theme.of(context).primaryColor,
      //               textStyle: TextStyle(color: Colors.white),
      //               iconColor: Colors.white,
      //             ),
      //           ]),
      //       child: Text("Complete"),
      //     ));
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

      // GlassCard_1x2(
      //     title: "Next Collection:",
      //     leftChild: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Text("None Scheduled"),
      //       ],
      //     ),
      //     rightChild: ElevatedButton(
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             PageTransition(
      //               type: PageTransitionType.fade,
      //               // alignment: Alignment.center,
      //               child: AddBookingScreen(),
      //               // childCurrent: this
      //             ));
      //       },
      //       child: Text("Schedule"),
      //     ));
    }
  }
}
