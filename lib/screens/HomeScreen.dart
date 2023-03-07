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
import 'package:restart/widgets/PastCollectionCard.dart';
import 'package:restart/widgets/ProfileCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 1.5 / 100,
            bottom: MediaQuery.of(context).size.height * 3 / 100),
        children: [
          ProfileCard(),
          verticalSpacing,
          NextCollectionCard(
              isScheduled:
                  true), //! either one of these 2 cards only depending on whether there is anything scheduled. For dateformat look at past collection card
          verticalSpacing,
          NextCollectionCard(
              isScheduled:
                  false), //! either one of these 2 cards only depending on whether there is anything scheduled. For dateformat look at past collection card
          verticalSpacing,
          Column(
            children: [
              PastCollectionCard(date: DateTime.now(), points: 65),
              verticalSpacing,
              PastCollectionCard(date: DateTime.now(), points: 65),
              verticalSpacing,
              PastCollectionCard(date: DateTime.now(), points: 65),
              verticalSpacing,
              PastCollectionCard(date: DateTime.now(), points: 65),
            ],
          ),
        ],
      ),
    );
  }
}
