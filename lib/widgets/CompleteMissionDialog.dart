import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/AuthController.dart';
import '../controllers/TxnController.dart';
import '../controllers/UserController.dart';
import 'GlassCards/GlassCard.dart';

showCompleteMissionDialog(
    bool doReload, BuildContext context, double weight) async {
  getTxnsAndMissions() async {
    AuthController auth = Get.put(AuthController());
    TxnController txnController = Get.put(TxnController());
    UserController user = Get.put(UserController());
    await txnController.getTxns();
    await user.getMissions();
    await user.getUserProfile();
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
            height: MediaQuery.of(context).size.height * 40 / 100,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 5 / 100,
                  vertical: MediaQuery.of(context).size.height * 2 / 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Thank you for contributing to a greener future!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.height * 2 / 100,
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      Text("You just completed a mission!",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 2 / 100,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      const Text("You gained!"),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 5 / 100),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 30 / 100,
                        child: OutlinedButton(
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
                  )
                ],
              ),
            ),
          ),
        );
      });
}
