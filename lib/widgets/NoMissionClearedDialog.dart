import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/widgets/layout/mission/MissionCard.dart';

import '../controllers/AuthController.dart';
import '../controllers/TxnController.dart';
import '../controllers/MissionController.dart';
import '../models/MissionModel.dart';
import 'GlassCards/GlassCard.dart';

noMissionClearedDialog(
  BuildContext context,
  double weight_collected,
  String missionTitle,
  String missionBody,
  double weight,
  double exp,
) async {
  getTxns() async {
    AuthController auth = Get.put(AuthController());
    TxnController txnController = Get.put(TxnController());
    //check if level up
    await txnController.getTxns();
    // await user.getMissions();
  }

  await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: GlassCard(
            height: MediaQuery.of(context).size.height * 42 / 100,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 5 / 100,
                  vertical: MediaQuery.of(context).size.height * 3 / 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Aw you almost made it!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, //!Maybe make responsive
                          color: Theme.of(context).primaryColor)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      Text(
                          "You recycled ${weight_collected.toStringAsFixed(2)}kg.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize:
                                MediaQuery.of(context).size.width * 3.5 / 100,
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      Text(
                          "You were only ${(weight - weight_collected).toStringAsFixed(2)}kg short of completing this mission:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize:
                                MediaQuery.of(context).size.width * 3.5 / 100,
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      MissionCard(weight: weight, exp: exp.toInt()),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      Text(
                          "Please fulfill the minimum quantity/weight next time!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize:
                                MediaQuery.of(context).size.width * 3.5 / 100,
                          )),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 30 / 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        await getTxns();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Continue",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
