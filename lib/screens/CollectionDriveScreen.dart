import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart/App.dart';
import 'package:restart/controllers/MiscDataController.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/Background.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';

class CollectionDriveScreen extends StatelessWidget {
  const CollectionDriveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MiscDataController controller = Get.put(MiscDataController());
    return CustomScaffold(
      body: ListView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 1.5 / 100,
            bottom: MediaQuery.of(context).size.height * 3 / 100),
        children: [
          GlassCard_header(
            height: MediaQuery.of(context).size.height * 90 / 100,
            header: Header(
              title: 'Upcoming Collection Update',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
                Column(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 75 / 100,
                        child: Text(
                            controller.collectionDriveData.isEmpty
                                ? "Hello there! We hope you're doing great."
                                : controller.collectionDriveData['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.width *
                                    4 /
                                    100))),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 2 / 100),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 75 / 100,
                        child: Text(
                            controller.collectionDriveData.isEmpty
                                ? "We're excited to share that during our last collection drive from June to August, we successfully collected 60KG of PET bottles! We're currently hard at work upcycling them."
                                : controller.collectionDriveData['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.width *
                                    4 /
                                    100))),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 2 / 100),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 75 / 100,
                        child: Text(
                            controller.collectionDriveData.isEmpty
                                ? "Looking ahead, we'll be coming right to your doorstep for our next collection drive in December! So go ahead, start saving those bottles now."
                                : controller.collectionDriveData['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.width *
                                    4 /
                                    100))),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 2 / 100),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 75 / 100,
                        child: Text(
                            controller.collectionDriveData.isEmpty
                                ? "We're looking forward to seeing you and your collection soon!"
                                : controller.collectionDriveData['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.width *
                                    4 /
                                    100))),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 10 / 100),
                OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 15 / 100,
                        child: Center(child: Text("Back")))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
