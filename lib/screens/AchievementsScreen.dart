import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/models/auth/UserModel.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:timelines/timelines.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<AchievementsScreen> {
  @override
  initState() {
    super.initState();
  }

  AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    UserModel user = auth.user.value!;
    List<dynamic> history = user.history;

    return CustomScaffold(
      body: Column(children: [
        GlassCard_header(
            header: Header(
              title: "History",
            ),
            height: MediaQuery.of(context).size.height * 40 / 100,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 5 / 100,
                    vertical: MediaQuery.of(context).size.height * 3 / 100),
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  builder: TimelineTileBuilder.fromStyle(
                    contentsAlign: ContentsAlign.alternating,
                    contentsBuilder: (context, index) => Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 5 / 100,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Recycled ${history[index]['weight_collected']}kg on ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(history[index]['date']))}",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 1 / 100),
                          history[index]['mission'] == "no-mission"
                              ? SizedBox(height: 0)
                              : Text(
                                  "+${history[index]['exp']} exp",
                                  textAlign: TextAlign.left,
                                ),
                        ],
                      ),
                    ),
                    itemCount: history.length,
                  ),
                ))),
        SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
        Text(
            "Total Weight: ${history.fold(0.0, (x, y) => double.parse(x.toString()) + y["weight_collected"]).toString()} kg"),
      ]),
    );
  }
}
