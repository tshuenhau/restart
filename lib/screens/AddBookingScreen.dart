import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/widgets/layout/Background.dart';
import 'package:restart/widgets/Bookings/Timeslots.dart';
import 'package:restart/widgets/GlassCards/GlassCard_headerfooter.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AddBookingScreen extends StatefulWidget {
  const AddBookingScreen({Key? key}) : super(key: key);

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey fullScreenKey = GlobalKey();
  GlobalKey dateKey = GlobalKey();
  GlobalKey timeslotsKey = GlobalKey();
  GlobalKey confirmKey = GlobalKey();
  final box = GetStorage();
  int navigationCount = 0;

  @override
  initState() {
    print("ADD BOOKING SCREEN");
    createTutorial();
    // Future.delayed(Duration.zero, showTutorial);
    timeslotController.getTimeslots();
    // box.write("showScheduleTutorial", null);

    super.initState();
  }

  @override
  dispose() {
    print('disposing add booking screen');
    super.dispose();
  }

  Future<void> executeAfterBuild() async {
    if (timeslotController.hasGottenTimeslots.value) {
      await Future.delayed(Duration.zero, showTutorial);
    }
    // this code will get executed after the build method
    // because of the way async functions are scheduled
  }

  late TimeslotController timeslotController = Get.put(TimeslotController());
  late TxnController txnController = Get.put(TxnController());
  AuthController auth = Get.find();

  late DateTime _selectedDate = DateTime.now().weekday == DateTime.sunday
      ? DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)
      : DateTime.now(); //! need to prevent this state from refreshing
  // late DateTime? _selectedDate;
  int? _selectedTimeslot;
  int? _selectedAvailTimeslot;

  void _selectTimeslot(DateTime selectedDate, int? selectedTimeslot,
      int? selectedAvailTimeslot) {
    setState(() {
      // _selectedDate = selectedDate;
      _selectedTimeslot = selectedTimeslot;
      _selectedAvailTimeslot = selectedAvailTimeslot;
    });
  }

  bool hasSelected() {
    return _selectedDate != null && _selectedTimeslot != null;
  }

  bool isFirstTimeLoad = true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (timeslotController.hasGottenTimeslots.value && isFirstTimeLoad) {
        isFirstTimeLoad = false;
        _selectedDate = timeslotController.availTimeslots[0].time;
        executeAfterBuild();
      }

      return !timeslotController.hasGottenTimeslots.value
          ? CustomScaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 5 / 100),
                  Text("Getting time slots..."),
                ],
              )),
            ) //TODO: Create a loading page/widget or smth
          : Stack(
              children: [
                CustomScaffold(
                  body: ListView(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 1.5 / 100,
                          bottom: MediaQuery.of(context).size.height * 3 / 100),
                      children: [
                        GlassCard_headerfooter(
                          header: Header(
                              leading: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    print('get out of add booking screen');
                                    //DISPOSE WIDGET HERE
                                  },
                                  icon: const Icon(Icons.arrow_back)),
                              title: "Book Collection"),
                          footer: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                15 /
                                                100,
                                        child: Center(child: Text("Back")))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        10 /
                                        100),
                                ElevatedButton(
                                  key: confirmKey,
                                  onPressed: hasSelected()
                                      ? () => showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                Dialog(
                                              backgroundColor: Colors.white
                                                  .withOpacity(0.95),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      25 /
                                                      100,
                                                  child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              2 /
                                                              100),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  60 /
                                                                  100,
                                                              child: Text(
                                                                  "Minimum collection requirement",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  60 /
                                                                  100,
                                                              child: Center(
                                                                child: Text(
                                                                    "Do you have at least 10 PET bottles ready for us to collect?"),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                OutlinedButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        15 /
                                                                        100,
                                                                    child:
                                                                        Center(
                                                                      child: const Text(
                                                                          'No'),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      10 /
                                                                      100,
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      hasSelected()
                                                                          ? () async {
                                                                              TimeslotModel timeslot = timeslotController.availTimeslots[_selectedAvailTimeslot!];
                                                                              EasyLoading.show(maskType: EasyLoadingMaskType.black, status: "loading");
                                                                              var res = await timeslotController.bookTimeslot(
                                                                                timeslot,
                                                                                auth.user.value!.address,
                                                                              );
                                                                              if (res != null) {
                                                                                var result = await txnController.createTxn(auth.user.value!.id, auth.user.value!.address, timeslot.time);
                                                                              }

                                                                              EasyLoading.dismiss();
                                                                              if (mounted) {
                                                                                // Navigator.pop(
                                                                                //     context);
                                                                                Navigator.of(context).popUntil((_) => navigationCount++ >= 2); //! This is not an elegant solution. DO change in the future.
                                                                              }
                                                                            }
                                                                          : null,
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        15 /
                                                                        100,
                                                                    child: Center(
                                                                        child: Text(
                                                                            'Yes')),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ]))),
                                            ),
                                          )
                                      : null,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          15 /
                                          100,
                                      child: Center(
                                        child: AutoSizeText(
                                          'Confirm',
                                          maxLines: 1,
                                        ),
                                      )),
                                ),
                              ]),
                          height: MediaQuery.of(context).size.height * 90 / 100,
                          body: Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      1 /
                                      100),
                              Container(
                                  key: dateKey,
                                  width: MediaQuery.of(context).size.width *
                                      85 /
                                      100,
                                  // height: MediaQuery.of(context).size.height * 20 / 100,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(213, 255, 255, 255),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    border: Border.all(
                                      width: 0,
                                      color: Theme.of(context).primaryColor,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              1.5 /
                                              100),
                                  child: CalendarTimeline(
                                    initialDate: _selectedDate,
                                    firstDate: DateTime.now().weekday ==
                                            DateTime.sunday
                                        ? DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day + 1)
                                        : DateTime.now(),
                                    lastDate: DateTime(
                                        DateTime.now().year +
                                            1, //TODO: revert once feature done
                                        DateTime.now().month + 1,
                                        DateTime.now().day),
                                    onDateSelected: (date) {
                                      setState(() {
                                        _selectedDate = date;
                                        _selectedTimeslot = null;
                                        _selectedAvailTimeslot = null;
                                      });
                                    },
                                    leftMargin: 20,
                                    monthColor: Theme.of(context).primaryColor,
                                    dayColor: Theme.of(context).primaryColor,
                                    activeDayColor: Colors.white,
                                    activeBackgroundDayColor:
                                        Theme.of(context).primaryColor,
                                    dotsColor: Colors.white,
                                    // selectableDayPredicate: (date) =>
                                    //     date.weekday != DateTime.sunday,
                                    locale: 'en_ISO',
                                  )),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0 /
                                      100),
                              Expanded(
                                child: TimeSlots(
                                    key: timeslotsKey,
                                    selectedDate: _selectedDate,
                                    selectTimeslot: _selectTimeslot,
                                    value: _selectedTimeslot,
                                    selectedAvailTimeslot:
                                        _selectedAvailTimeslot),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                Positioned(
                    left: MediaQuery.of(context).size.width / 2,
                    top: -50,
                    child: SizedBox(key: fullScreenKey))
              ],
            );
    });
  }

  void showTutorial() {
    if (box.read("showScheduleTutorial") == false) {
      return;
    } else {
      tutorialCoachMark.show(context: context);
    }
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.blue,
      textSkip: "SKIP",
      paddingFocus: 5,
      opacityShadow: 0.85,
      onFinish: () {
        box.write("showScheduleTutorial", false);
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        box.write("showScheduleTutorial", false);

        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "fullScreen",
        keyTarget: fullScreenKey,
        alignSkip: Alignment.topRight,
        // targetPosition: TargetPosition(const Size(0, 0), Offset(0, -1)),
        shape: ShapeLightFocus.Circle,
        enableOverlayTab: true,
        radius: 0,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 45 / 100),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 50 / 100),
                  const Text(
                    "Here's how you schedule a collection! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "date",
        keyTarget: dateKey,
        alignSkip: Alignment.topRight,
        // targetPosition: TargetPosition(const Size(0, 0), Offset(0, -1)),
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 45 / 100),

                  const Text(
                    "First, select a date here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "timeslot",
        keyTarget: timeslotsKey,
        alignSkip: Alignment.topRight,
        // targetPosition: TargetPosition(const Size(0, 0), Offset(0, -1)),
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 45 / 100),

                  const Text(
                    "Next, select an available time slot.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  const Text(
                    "*Unavailable time slots will be greyed out.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "confirm",
        keyTarget: confirmKey,
        alignSkip: Alignment.topRight,
        // targetPosition: TargetPosition(const Size(0, 0), Offset(0, -1)),
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 45 / 100),

                  const Text(
                    "Finally, tap confirm and wait for us to arrive!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "fullscreen",
        keyTarget: fullScreenKey,
        alignSkip: Alignment.topRight,
        // targetPosition: TargetPosition(const Size(0, 0), Offset(0, -1)),
        shape: ShapeLightFocus.RRect,
        radius: DEFAULT_RADIUS,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 50 / 100),
                  const Text(
                    "Please also ensure that you have at least 10 PET bottles for us to collect each time.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 100),
                  const Text(
                    "Happy recycling!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }
}
