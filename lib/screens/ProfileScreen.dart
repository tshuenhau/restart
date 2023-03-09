import 'package:flutter/material.dart';
import 'package:restart/screens/CustomScaffold.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/GlassCard.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/ProfileFieldCard.dart';
import 'package:restart/widgets/layout/VerticalSpacing.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScaffold(
            body: ListView(
          children: [
            GlassCard_header(
              header: Header(
                title: "Name",
                navigateBack: true,
              ),
              height: MediaQuery.of(context).size.height * 38 / 100,
              child: ExperienceSection(current: 875, max: 1200),
            ),
            VerticalSpacing(),
            ProfileFieldCard(title: "Name", value: auth.user.value!.name),

            VerticalSpacing(),
            ProfileFieldCard(title: "Email", value: auth.user.value!.email),
            VerticalSpacing(),
            ProfileFieldCard(
                title: "Address", value: auth.user.value!.address, maxLines: 2),
            // VerticalSpacing(),
            // ProfileFieldCard(title: "Password:", value: "***********"),
            VerticalSpacing(),
            // GlassCard(
            //     height: MediaQuery.of(context).size.height * 18 / 100,
            //     child:
            //         Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //       Align(
            //         child: SizedBox(
            //             width: double.infinity,
            //             child: ElevatedButton(
            //                 onPressed: () {}, child: Text("Change Password"))),
            //       ),
            //       Align(
            //         child: SizedBox(
            //             width: MediaQuery.of(context).size.width * 45 / 100,
            //             child: OutlinedButton(
            //                 onPressed: () {}, child: Text("Log Out"))),
            //       ),
            //     ])),
            Align(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 45 / 100,
                  child: ElevatedButton(
                      onPressed: () {}, child: Text("Change Password"))),
            ),
            Align(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 45 / 100,
                  child: OutlinedButton(
                      onPressed: () async {
                        await auth.signOutFromGoogle();
                      },
                      child: Text(
                        "Log Out",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
            ),
            VerticalSpacing(),
          ],
        )));
  }
}
