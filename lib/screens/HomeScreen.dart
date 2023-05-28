import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:restart/assets/constants.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/widgets/NextCollectionCard.dart';
import 'package:restart/widgets/PastCollectionCard.dart';
import 'package:restart/widgets/ProfileCard.dart';

import '../controllers/AuthController.dart';
import '../controllers/UserController.dart';
import '../widgets/GlassCards/GlassCard.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(
      {Key? key,
      required this.experienceKey,
      required this.homeForestKey,
      required this.scheduleKey,
      required this.profileKey})
      : super(key: key);

  late Key experienceKey;
  late Key homeForestKey;
  late Key scheduleKey;
  late Key profileKey;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    print("Home");
    super.initState();
  }

  TxnController txnController = Get.find();
  UserController user = Get.put(UserController());
  AuthController auth = Get.find();
  @override
  Widget build(BuildContext context) {
    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

    return Obx(() {
      if (user.isLevelUp.value) {
        SchedulerBinding.instance.addPostFrameCallback(
            (Duration duration) => _showLevelUpDialog(context));
        user.isLevelUp.value = false;
      }

      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.5 / 100,
              bottom: MediaQuery.of(context).size.height * 3 / 100),
          shrinkWrap: true,
          children: [
            ProfileCard(
              homeForestKey: widget.homeForestKey,
              experienceKey: widget.experienceKey,
              profileKey: widget.profileKey,
            ),
            verticalSpacing,
            txnController.upcomingTxns.isEmpty &&
                    txnController.hasInitialised.value
                ? Container()
                : txnController.upcomingTxns.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Column(children: [
                            NextCollectionCard(isScheduled: true, i: i),
                            verticalSpacing,
                          ]);
                        },
                        itemCount: txnController.upcomingTxns.length,
                      )
                    : const SizedBox(),
            SizedBox(
                key: widget.scheduleKey,
                child: NextCollectionCard(isScheduled: false, i: null)),
            verticalSpacing,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Column(children: [
                  PastCollectionCard(i: i),
                  verticalSpacing,
                ]);
              },
              itemCount: txnController.completedTxns.length,
            ),
          ],
        ),
      );
    });
  }

  _showLevelUpDialog(BuildContext context) {
    print('showing level up dialog!');
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: GlassCard(
              height: MediaQuery.of(context).size.height * 30 / 100,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 2 / 100,
                    vertical: MediaQuery.of(context).size.height * 2 / 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("LEVEL UP!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text("Level " + auth.user.value!.level.toString(),
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text(
                            'Congratulations ${auth.user.value!.name}! 🥳🥳🥳'),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text("A new tree has grown in your forest!"),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 30 / 100,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Continue",
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
