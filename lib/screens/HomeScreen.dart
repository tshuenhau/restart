import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:restart/screens/AddBookingScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/GlassCards/GlassCard_1x2.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:page_transition/page_transition.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:restart/widgets/NextCollectionCard.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/controllers/AuthController.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TxnController txnController = Get.put(TxnController());
    UserController userController = Get.put(UserController());
    AuthController auth = Get.find();
    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.5 / 100,
              bottom: MediaQuery.of(context).size.height * 3 / 100),
          children: [
            GlassCard_header(
                header: Header(
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.account_circle)),
                    title: auth.user.value!.name),
                height: MediaQuery.of(context).size.height * 38 / 100,
                child: ExperienceSection(current: 875, max: 1200)),
            verticalSpacing,
            txnController.upcomingTxns.isNotEmpty
                ? NextCollectionCard(isScheduled: true)
                : const SizedBox(),
            verticalSpacing,
            txnController.upcomingTxns.isNotEmpty
                ? NextCollectionCard(isScheduled: false)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
