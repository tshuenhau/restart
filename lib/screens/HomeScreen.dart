import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/NextCollectionCard.dart';
import 'package:restart/widgets/PastCollectionCard.dart';
import 'package:restart/widgets/ProfileCard.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';

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

  @override
  Widget build(BuildContext context) {
    TxnController txnController = Get.find();
    AuthController auth = Get.find();
    UserController user = Get.put(UserController());

    Widget verticalSpacing =
        SizedBox(height: MediaQuery.of(context).size.height * 2 / 100);

    return Obx(() => SizedBox(
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
                  ? verticalSpacing
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
        ));
  }
}
