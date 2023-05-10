import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restart/widgets/NextCollectionCard.dart';
import 'package:restart/widgets/PastCollectionCard.dart';
import 'package:restart/widgets/ProfileCard.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/controllers/AuthController.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TxnController txnController = Get.find();
    AuthController auth = Get.find();
    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

    return Obx(() => (txnController.hasInitialised.value &&
            (txnController.upcomingTxns.isNotEmpty ||
                txnController.completedTxns.isNotEmpty))
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 1.5 / 100,
                  bottom: MediaQuery.of(context).size.height * 3 / 100),
              shrinkWrap: true,
              children: [
                ProfileCard(key: UniqueKey()),
                verticalSpacing,
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Column(children: [
                      NextCollectionCard(isScheduled: true, i: i),
                      verticalSpacing,
                    ]);
                  },
                  itemCount: txnController.upcomingTxns.length,
                ),
                NextCollectionCard(isScheduled: false, i: null),
                verticalSpacing,
                // Text("History", style: TextStyle()),
                Container(
                    child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Column(children: [
                      PastCollectionCard(i: i),
                      verticalSpacing,
                    ]);
                  },
                  itemCount: txnController.completedTxns.length,
                )),
              ],
            ),
          )
        : Container());
  }
}
