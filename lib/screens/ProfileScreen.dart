import 'package:flutter/material.dart';
import 'package:restart/screens/CustomScaffold.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/GlassCard.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/ProfileFieldCard.dart';
import 'package:restart/widgets/layout/VerticalSpacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
        ProfileFieldCard(title: "Email:", value: "tshuenhau@gmail.com"),
        VerticalSpacing(),
        ProfileFieldCard(title: "Name:", value: "Chong Tshuen Hau"),
        VerticalSpacing(),
        ProfileFieldCard(
            title: "Address",
            value: "123 Abc, Road of lmaos,123 Abc, Road of lmaos",
            maxLines: 2),
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
              child: OutlinedButton(onPressed: () {}, child: Text("Log Out"))),
        ),
        VerticalSpacing(),
      ],
    ));
  }
}
