import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/AuthController.dart';
import 'GlassCards/GlassCard.dart';
import 'GlassCards/GlassCard_header.dart';
import 'Glasscards/Header.dart';

class StampCard extends StatefulWidget {
  const StampCard({Key? key}) : super(key: key);

  @override
  State<StampCard> createState() => _StampCardState();
}

class _StampCardState extends State<StampCard> {
  AuthController auth = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GlassCard_header(
        height: MediaQuery.of(context).size.height * 30 / 100,
        header: Header(title: "${auth.user.value!.name}'s Stamp Card"),
        width: MediaQuery.of(context).size.width * 90 / 100,
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: MediaQuery.of(context).size.width * 2 / 100,
            children: List<Widget>.generate(150, (int i) {
              return Icon(
                Icons.local_drink_outlined,
                color: Colors.white70,
                size: MediaQuery.of(context).size.width * 7 / 100,
              );
            }),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 100,
      ),
      ElevatedButton(child: Text("Pledge"), onPressed: () {})
    ]);
  }
}
