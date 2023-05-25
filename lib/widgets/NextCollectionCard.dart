import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restart/screens/AddBookingScreen.dart';
import 'package:restart/screens/MissionsScreen.dart';
import 'package:restart/widgets/Glasscards/GlassCard_1x2_Transition.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';
import 'package:animations/animations.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'package:restart/models/TransactionModel.dart';

class NextCollectionCard extends StatelessWidget {
  NextCollectionCard({Key? key, required this.isScheduled, required this.i})
      : super(key: key);

  bool isScheduled;
  int? i;
  TxnController txnController = Get.find();
  TimeslotController timeslotController = Get.put(TimeslotController());

  @override
  Widget build(BuildContext context) {
    //TODO: put proper index over here
    if (isScheduled && txnController.upcomingTxns.isNotEmpty && i != null) {
      return Obx(() => GlassCard_1x2(
            leftChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat.jm()
                    .format(txnController.upcomingTxns[i!].date)),
                Text(DateFormat.MMMMd()
                    .format(txnController.upcomingTxns[i!].date)),
                // SizedBox(height: 10),
                // AutoSizeText(
                //   "107D Edgefields PlainsPlainsPlainsPlainsPlains",
                //   overflow: TextOverflow.ellipsis,
                //   textAlign: TextAlign.center,
                //   maxLines: 1,
                // )
              ],
            ),
            rightChild:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              txnController.upcomingTxns[i!].status == TXN_STATUS.COMPLETED
                  ? ElevatedButton(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 16 / 100,
                          child: AutoSizeText(
                            "Complete",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          )),
                      onPressed: () {},
                    )
                  : Container(),
              OutlinedButton(
                onPressed: () async {
                  TransactionModel txn = txnController.upcomingTxns[i!];
                  var result = await txnController.cancelTxn(txn);
                  if (result == null) {
                    return;
                  }
                  TimeslotModel? timeslot =
                      await timeslotController.getTimeslotByDate(txn.date);
                  if (timeslot == null) {
                    print('error getting timeslot');
                    return;
                  }
                  var res = await timeslotController.clearTimeslot(timeslot);
                  if (res == null) {
                    print('error freeing timeslot');
                    return;
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 16 / 100,
                  child: Text(
                    "Cancel",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ]),
            title: 'Next Collection',
          ));
    } else if (!isScheduled && txnController.upcomingTxns.isEmpty) {
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
    } else {
      return Container();
    }

    // return Obx(() => GlassCard_1x2_Transition(
    //     buttonText: 'Complete',
    //     leftChild: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(DateFormat.jm().format(txnController.upcomingTxns[i!].date)),
    //         Text(DateFormat.MMMMd()
    //             .format(txnController.upcomingTxns[0].date)),
    //       ],
    //     ),
    //     title: "Next Collection",
    //     navigateTo: ExperienceUpScreen(mission: mission)));
  }
}
