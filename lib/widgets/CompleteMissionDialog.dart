import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/assets/ScaleSize.dart';
import 'package:restart/widgets/layout/mission/MissionCard.dart';

import '../controllers/AuthController.dart';
import '../controllers/TxnController.dart';
import '../controllers/UserController.dart';
import 'GlassCards/GlassCard.dart';

showCompleteMissionDialog(
    bool doReload,
    BuildContext context,
    String missionTitle,
    String missionBody,
    double weight,
    double exp,
    double weight_collected) async {
  getTxnsAndMissions() async {
    AuthController auth = Get.put(AuthController());
    TxnController txnController = Get.put(TxnController());
    UserController user = Get.put(UserController());
    //check if level up
    bool isLevelUp =
        auth.user.value!.current_points + exp >= auth.user.value!.exp_for_level;

    await txnController.getTxns();
    // await user.getMissions();
    await user.getUserProfile();
    if (isLevelUp) {
      user.isLevelUp.value = true;
      await user.updateForest();
    }
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
                  Text("Mission Completed!",
                      textAlign: TextAlign.center,
                      textScaleFactor: ScaleSize.textScaleFactor(context),
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
                          "Congratulations! You recycled ${weight_collected} kg and completed this mission:",
                          textScaleFactor: ScaleSize.textScaleFactor(context),
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
                      Text("Thank you for contributing to a greener future!",
                          textScaleFactor: ScaleSize.textScaleFactor(context),
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
                        Navigator.pop(context);
                        if (doReload) {
                          await getTxnsAndMissions();
                        }
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
