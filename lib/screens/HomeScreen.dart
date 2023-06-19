import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/widgets/CompleteMissionDialog.dart';
import 'package:restart/widgets/NextCollectionCard.dart';
import 'package:restart/widgets/PastCollectionCard.dart';
import 'package:restart/widgets/ProfileCard.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_share/social_share.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkPermissions();
    });
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAnalytics.instance.setCurrentScreen(
        screenName: 'Home Screen',
        screenClassOverride: 'Screens',
      );
    });
    print("Home");
  }

  TxnController txnController = Get.find();
  UserController user = Get.put(UserController());
  AuthController auth = Get.find();
  @override
  Widget build(BuildContext context) {
    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

    return Obx(() {
      print('is level up? ' + user.isLevelUp.value.toString());
      if (user.isLevelUp.value) {
        SchedulerBinding.instance.addPostFrameCallback((Duration duration) =>
            _showLevelUpDialog(context, user.isLevelUp.value.toString()));
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
            // ElevatedButton(
            //     onPressed: () async {
            //       await showCompleteMissionDialog(
            //           true, context, "TItle", "erh", 1, 12.toDouble());
            //     },
            //     child: Text("wegewr")),
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
                            NextCollectionCard(
                                buildContext: context, isScheduled: true, i: i),
                            verticalSpacing,
                          ]);
                        },
                        itemCount: txnController.upcomingTxns.length,
                      )
                    : verticalSpacing,
            txnController.hasInitialised.value
                ? SizedBox(
                    key: widget.scheduleKey,
                    child: NextCollectionCard(
                        buildContext: null, isScheduled: false, i: null))
                : SizedBox(
                    child: Center(child: CircularProgressIndicator()),
                    width: MediaQuery.of(context).size.width * 5 / 100,
                  ),
            // verticalSpacing,
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, i) {
            //     return Column(children: [
            //       PastCollectionCard(i: i),
            //       verticalSpacing,
            //     ]);
            //   },
            //   itemCount: txnController.completedTxns.length,
            // ),
          ],
        ),
      );
    });
  }

  _showLevelUpDialog(BuildContext context, String level) {
    // print('showing level up dialog!');

    String level = auth.user.value!.level.toString();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: GlassCard(
              height: MediaQuery.of(context).size.height * 35 / 100,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 2 / 100,
                    vertical: MediaQuery.of(context).size.height * 2 / 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("You've leveled up to Level " + level,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)), //TODO:Maybe make this responsive
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        // Text(
                        //     "You've leveled up to Level " +
                        //         auth.user.value!.level.toString(),
                        //     style: TextStyle(fontSize: 16)),
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
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 30 / 100,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseAnalytics.instance
                                  .logEvent(name: 'share');
                              SocialShare.shareOptions(
                                  "Just reached level $level in RE:start! 🚀 Join me on this exciting journey of gamified recycling and contribute to a sustainable future. Be part of the movement and make a positive impact!\n\n https://getrestartapp.com/");
                            },
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 16 / 100,
                              child: AutoSizeText(
                                "Share",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 16 / 100,
                              child: AutoSizeText("Continue",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showPermissionsDialog(BuildContext context) async {
    print('showing permissions dialog!');

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
                    horizontal: MediaQuery.of(context).size.width * 3 / 100,
                    vertical: MediaQuery.of(context).size.height * 2 / 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Turn on your notifications",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text(
                            "For real-time updates, exclusive offers, and personalized content!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Text(
                          "Don't worry! You will not be spammed",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 2 / 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Don't Allow",
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 2 / 100,
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  PermissionStatus status =
                                      await Permission.notification.status;
                                  if (status.isPermanentlyDenied) {
                                    await openAppSettings();
                                  } else if (status.isDenied) {
                                    status =
                                        await Permission.notification.request();
                                    if (status.isDenied) {
                                      await openAppSettings();
                                    }
                                  }

                                  print(status);

                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Allow",
                                ),
                              ),
                            ),
                          ],
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

  _checkPermissions() async {
    var status = await Permission.notification.status;
    print(status);
    if ((status.isDenied || status.isPermanentlyDenied)) {
      if (auth.showHomeTutorial.value != null) {
        if (!auth.showHomeTutorial.value!) {
          await _showPermissionsDialog(context);
        }
        ever(auth.showHomeTutorial, (_) async {
          if (!auth.showHomeTutorial.value!) {
            await _showPermissionsDialog(context);
          }
        });
      }
    }
  }
}
