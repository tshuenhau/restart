import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restart/screens/AddBookingScreen.dart';
import 'package:restart/screens/ExperienceUpScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/Glasscards/GlassCard_1x2_Transition.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:intl/intl.dart';

class NextCollectionCard extends StatelessWidget {
  NextCollectionCard({Key? key, required this.isScheduled, required this.i})
      : super(key: key);

  bool isScheduled;
  int? i;
  @override
  Widget build(BuildContext context) {
    TxnController txnController = Get.find();

    //TODO: put proper index over here

    if (isScheduled && txnController.upcomingTxns.isNotEmpty) {
      return Obx(() => GlassCard_1x2(
            leftChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat.jm()
                    .format(txnController.upcomingTxns[i!].date)),
                Text(DateFormat.MMMMd()
                    .format(txnController.upcomingTxns[0].date)),
              ],
            ),
            rightChild:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 16 / 100,
                    child: AutoSizeText(
                      "Complete",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    )),
                onPressed: () {},
              ),
              OutlinedButton(
                  onPressed: () {
                    txnController.cancelTxn(txnController.upcomingTxns[i!]);
                  }, //TODO: ZQ here delete the bs
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 16 / 100,
                      child: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                      )))
            ]),
            title: 'Next Collection',
          ));

      return Obx(() => GlassCard_1x2_Transition(
          buttonText: 'Complete',
          leftChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat.jm().format(txnController.upcomingTxns[i!].date)),
              Text(DateFormat.MMMMd()
                  .format(txnController.upcomingTxns[0].date)),
            ],
          ),
          title: "Next Collection",
          navigateTo: ExperienceUpScreen()));
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
