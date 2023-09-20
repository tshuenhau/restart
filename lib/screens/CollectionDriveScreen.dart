import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart/App.dart';
import 'package:restart/controllers/MiscDataController.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/layout/Background.dart';

class CollectionDriveScreen extends StatelessWidget {
  const CollectionDriveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MiscDataController controller = Get.put(MiscDataController());
    return Background(
      child: GlassCard(
        height: MediaQuery.of(context).size.height * 25 / 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
            SizedBox(
                width: MediaQuery.of(context).size.width * 75 / 100,
                child: Text(
                    controller.collectionDriveData.isEmpty
                        ? "No collections for the time being..."
                        : controller.collectionDriveData['text'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.width * 4 / 100))),
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
    );
  }
}
