import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/screens/EditProfileScreen.dart';
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
    AuthController auth = Get.find();
    return CustomScaffold(
      body: ListView(
        children: [
          OpenContainer(
            tappable: false,
            closedElevation: 0,
            openElevation: 0,
            middleColor: Colors.transparent,
            closedColor: Colors.transparent,
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return Obx(
                () => GlassCard_header(
                  header: Header(
                    title: auth.user.value!.name,
                    trailing: IconButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: openContainer,
                        icon: const Icon(Icons.edit)),
                    navigateBack: true,
                  ),
                  height: MediaQuery.of(context).size.height * 45 / 100,
                  child: ExperienceSection(
                      key: const ValueKey(1),
                      current: auth.user.value!.current_points.toDouble(),
                      level: auth.user.value!.level),
                ),
              );
            },
            openBuilder: (BuildContext _, VoidCallback openContainer) {
              return EditProfileScreen();
            },
          ),
          VerticalSpacing(),

          // ProfileFieldCard(
          //     title: "Address",
          //     value: auth.user.value!.address,
          //     maxLines: 2), //TODO:Remove this later on
          // VerticalSpacing(),
          // ProfileFieldCard(title: "Password:", value: "***********"),
          // VerticalSpacing(),
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
          // Align(
          //   child: SizedBox(
          //       width: MediaQuery.of(context).size.width * 45 / 100,
          //       child: ElevatedButton(
          //           onPressed: () {}, child: Text("Change Password"))),
          // ),
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
      ),
    );
  }
}
