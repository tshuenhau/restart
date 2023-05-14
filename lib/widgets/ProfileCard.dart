import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:restart/screens/ProfileScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/AuthController.dart';
import 'Glasscards/GlassCard_header.dart';

class ProfileCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    return OpenContainer(
      tappable: false,
      closedElevation: 0,
      openElevation: 0,
      middleColor: Colors.transparent,
      closedColor: Colors.transparent,
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return GlassCard_header(
            header: Header(
                trailing: IconButton(
                    key: profileKey,
                    color: Theme.of(context).primaryColor,
                    onPressed: openContainer,
                    icon: const Icon(Icons.account_circle)),
                title: auth.user.value!.name),
            height: MediaQuery.of(context).size.height * 45 / 100,
            child: ExperienceSection(
                homeForestKey: homeForestKey,
                experienceKey: experienceKey,
                current: 875,
                max: 1200));
      },
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return ProfileScreen();
      },
    );
  }
}
