import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restart/controllers/MiscDataController.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'package:restart/models/TransactionModel.dart';
import 'package:restart/screens/AddBookingScreen.dart';
import 'package:restart/screens/CollectiveDriveScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';
import 'package:restart/widgets/Glasscards/GlassCard_1x2_Transition.dart';

import '../controllers/AuthController.dart';
import '../screens/SetDetailsScreen.dart';
import 'GlassCards/GlassCard.dart';

class NextCollectionCard extends StatelessWidget {
  NextCollectionCard(
      {Key? key,
      required this.isScheduled,
      required this.i,
      required this.buildContext})
      : super(key: key);

  bool isScheduled;
  int? i;
  BuildContext? buildContext;
  TxnController txnController = Get.find();
  TimeslotController timeslotController = Get.put(TimeslotController());
  MiscDataController controller = Get.put(MiscDataController());

  AuthController auth = Get.find();

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
                  showCancelTxnDialog();
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
          navigateTo: auth.isUserInfoComplete()
              ? CollectionDriveScreen()
              : SetDetailsScreen());
    } else {
      return Container();
    }
  }

  showCancelTxnDialog() {
    showDialog(
        context: buildContext!,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: GlassCard(
              height: MediaQuery.of(context).size.height * 30 / 100,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 3 / 100,
                    vertical: MediaQuery.of(context).size.height * 2 / 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Are you sure?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text("This action is irreversible.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Back",
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 2 / 100,
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  TransactionModel txn =
                                      txnController.upcomingTxns[i!];
                                  var result =
                                      await txnController.cancelTxn(txn);
                                  if (result == null) {
                                    return;
                                  }
                                  TimeslotModel? timeslot =
                                      await timeslotController
                                          .getTimeslotByDate(txn.date);
                                  if (timeslot == null) {
                                    print('error getting timeslot');
                                    return;
                                  }
                                  var res = await timeslotController
                                      .clearTimeslot(timeslot);
                                  if (res == null) {
                                    print('error freeing timeslot');
                                    return;
                                  }
                                },
                                child: Text(
                                  "Confirm",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
