import 'package:flutter/material.dart';
import 'package:restart/screens/CustomScaffold.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/Glasscards/Header.dart';

import '../widgets/Glasscards/GlassCard_header.dart';

class ExperienceUpScreen extends StatelessWidget {
  const ExperienceUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: GlassCard_header(
          header: Header(title: "Name"),
          height: MediaQuery.of(context).size.height * 90 / 100,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 45 / 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("+75 points"),
                ExperienceSection(),
                Text("LEVEL UP"),
                ElevatedButton(onPressed: () {}, child: Text("Continue"))
              ],
            ),
          )),
    );
  }
}
