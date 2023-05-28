import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/ProfileScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/Glasscards/Header.dart';

import '../controllers/UserController.dart';
import 'Glasscards/GlassCard_header.dart';

class ProfileCard extends StatefulWidget {
  ProfileCard(
      {Key? key,
      required this.homeForestKey,
      required this.experienceKey,
      this.profileKey})
      : super(key: key);

  late Key homeForestKey;
  late Key experienceKey;
  late Key? profileKey;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late Key expSectionKey;

  AuthController auth = Get.find();
  UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: false,
      closedElevation: 0,
      openElevation: 0,
      middleColor: Colors.transparent,
      closedColor: Colors.transparent,
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return Obx(() {
          print("rebuild widget " + user.increase.value.toString());
          return GlassCard_header(
              header: Header(
                  trailing: IconButton(
                      key: widget.profileKey,
                      color: Theme.of(context).primaryColor,
                      onPressed: openContainer,
                      icon: const Icon(Icons.account_circle)),
                  title: auth.user.value?.name ?? ""),
              height: MediaQuery.of(context).size.height * 45 / 100,
              child: ExperienceSection(
                increase: user.increase.value.toDouble(),
              ));
        });
      },
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return ProfileScreen();
      },
    );
  }
}
