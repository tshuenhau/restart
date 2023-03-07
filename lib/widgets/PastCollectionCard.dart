import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:restart/widgets/Glasscards/GlassCard_1x2_Transition.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';
import 'package:intl/intl.dart';

class PastCollectionCard extends StatelessWidget {
  PastCollectionCard({required this.date, required this.points, Key? key})
      : super(key: key);
  late DateTime date;
  late int points;
  //!To Format Date:
  //! https://i0.wp.com/www.flutterbeads.com/wp-content/uploads/2022/01/watermark_Datetime1.png?resize=492%2C1024&ssl=1

  @override
  Widget build(BuildContext context) {
    return GlassCard_1x2(
      leftChild: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(DateFormat.MMMd().format(DateTime.now()).toString()),
        Text(DateFormat.jm().format(DateTime.now()).toString()),
      ]),
      rightChild: Text("+" + points.toString() + " points"),
      title: 'Date Collected',
    );
  }
}
