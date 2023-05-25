import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';

class PastCollectionCard extends StatelessWidget {
  PastCollectionCard({Key? key, required this.i}) : super(key: key);
  int? i;
  //!To Format Date:
  //! https://i0.wp.com/www.flutterbeads.com/wp-content/uploads/2022/01/watermark_Datetime1.png?resize=492%2C1024&ssl=1

  @override
  Widget build(BuildContext context) {
    TxnController txnController = Get.find();
    TimeslotController timeslotController = Get.put(TimeslotController());
    return GlassCard_1x2(
      leftChild: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(DateFormat.jm().format(txnController.completedTxns[i!].date)),
        Text(DateFormat.MMMMd().format(txnController.completedTxns[i!].date)),
      ]),
      rightChild: Text(
          "+" + txnController.completedTxns[i!].weight.toString() + " bottles"),
      title: 'Date Collected',
    );
  }
}
