import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'package:restart/widgets/Bookings/Timeslots.dart';
import 'package:restart/widgets/GlassCards/GlassCard_headerfooter.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    createTutorial();
    // Future.delayed(Duration.zero, showTutorial);
    timeslotController.getTimeslots();
    // box.write("showScheduleTutorial", null);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseAnalytics.instance.setCurrentScreen(
        screenName: 'Add Booking Screen',
        screenClassOverride: 'Screens',
      );
    });
    super.initState();
  }

  @override
  dispose() {
    print('disposing add booking screen');
    timeslotController.availTimeslots.clear();
    timeslotController.currentDate = DateTime.now();
    timeslotController.isNoMoreSlots.value = false;
    timeslotController.alrShowNoSlots.value = false;
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

  late DateTime _selectedDate =
      DateTime.now(); //! need to prevent this state from refreshing
  // late DateTime? _selectedDate;
  int? _selectedTimeslot;
  int? _selectedAvailTimeslot;

  void _selectTimeslot(DateTime selectedDate, int? selectedTimeslot,
      int? selectedAvailTimeslot) {
    setState(() {
      _selectedDate = selectedDate;
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
      if (timeslotController.hasGottenTimeslots.value &&
          isFirstTimeLoad &&
          timeslotController.availTimeslots.isNotEmpty) {
        isFirstTimeLoad = false;

        _selectedDate = timeslotController.availTimeslots[0].time;
        print(_selectedDate);
        executeAfterBuild();
      }
      if (timeslotController.hasGottenTimeslots.value &&
          timeslotController.isNoMoreSlots.value &&
          !timeslotController.alrShowNoSlots.value) {
        print('showing no more time slots');
        Fluttertoast.showToast(
            msg: "No more time slots!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        timeslotController.alrShowNoSlots.value = true;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // Perform an action after the build is completed
          setState(() {
            _selectedDate = timeslotController.availTimeslots.last.time;
          });
        });
      }

      return timeslotController.hasGottenTimeslots.value &&
              timeslotController.availTimeslots.isEmpty
          ? CustomScaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 5 / 100),
                  Text("No more slots for the time being...",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Come back again later!",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Back')),
                ],
              )),
            )
          : !timeslotController.hasGottenTimeslots.value
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
                              top: MediaQuery.of(context).size.height *
                                  1.5 /
                                  100,
                              bottom:
                                  MediaQuery.of(context).size.height * 3 / 100),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                15 /
                                                100,
                                            child:
                                                Center(child: Text("Back")))),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                10 /
                                                100),
                                    ElevatedButton(
                                      key: confirmKey,
                                      onPressed: hasSelected()
                                          ? () => showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Dialog(
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.95),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              40 /
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
                                                                      "Collection requirement",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      60 /
                                                                      100,
                                                                  child: Column(
                                                                      children: [
                                                                        Text(
                                                                            "Please ensure you have done the following:",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold)),
                                                                        SizedBox(
                                                                          height: MediaQuery.of(context).size.width *
                                                                              4 /
                                                                              100,
                                                                        ),
                                                                        RichText(
                                                                            text: TextSpan(
                                                                                style: TextStyle(color: Colors.black),
                                                                                children: [
                                                                                      TextSpan(text: "1. Do you have at least"),
                                                                                    ] +
                                                                                    MINIMUM_QUANTITY +
                                                                                    [
                                                                                      TextSpan(text: " PET bottles ready for us to collect?"),
                                                                                    ])),
                                                                        SizedBox(
                                                                          height: MediaQuery.of(context).size.width *
                                                                              2 /
                                                                              100,
                                                                        ),
                                                                        RichText(
                                                                            text: TextSpan(
                                                                                style: TextStyle(color: Colors.black),
                                                                                children: [
                                                                              TextSpan(text: "2. Have you "),
                                                                              TextSpan(text: "emptied", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                              TextSpan(
                                                                                text: " and ",
                                                                              ),
                                                                              TextSpan(text: "rinsed", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                              TextSpan(text: " your bottles?"),
                                                                            ])),
                                                                      ]),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    OutlinedButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            15 /
                                                                            100,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              const Text('No'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          10 /
                                                                          100,
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed: hasSelected()
                                                                          ? () {
                                                                              showEnterNumOfBottlesDialog(context);
                                                                            }
                                                                          : null,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            15 /
                                                                            100,
                                                                        child: Center(
                                                                            child:
                                                                                Text('Yes')),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ]))),
                                                ),
                                              )
                                          : null,
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                              height:
                                  MediaQuery.of(context).size.height * 90 / 100,
                              body: Column(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(
                                          DateTime.now().year +
                                              1, //TODO: revert once feature done
                                          DateTime.now().month + 1,
                                          DateTime.now().day),
                                      onDateSelected: (date) async {
                                        DateTime d = timeslotController
                                            .currentDate
                                            .add(const Duration(days: 5));
                                        DateTime refreshDate =
                                            DateTime(d.year, d.month, d.day);
                                        if (date.isAfter(refreshDate) ||
                                            date.isAtSameMomentAs(
                                                refreshDate)) {
                                          timeslotController.currentDate =
                                              refreshDate;
                                          EasyLoading.show(
                                              maskType:
                                                  EasyLoadingMaskType.black,
                                              status: "Loading...");

                                          await timeslotController
                                              .getTimeslots();
                                          EasyLoading.dismiss();
                                        }
                                        setState(() {
                                          _selectedDate = date;
                                          _selectedTimeslot = null;
                                          _selectedAvailTimeslot = null;
                                        });
                                      },
                                      leftMargin: 20,
                                      monthColor:
                                          Theme.of(context).primaryColor,
                                      dayColor: Theme.of(context).primaryColor,
                                      activeDayColor: Colors.white,
                                      activeBackgroundDayColor:
                                          Theme.of(context).primaryColor,
                                      dotsColor: Colors.white,
                                      // selectableDayPredicate: (date) =>
                                      //     date.weekday != DateTime.sunday,
                                      locale: 'en_ISO',
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                    "Please also ensure that you have at least 25 PET bottles for us to collect each time and they are emptied and rinsed.",
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

  showNoSlotsDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
            height: MediaQuery.of(context).size.height * 50 / 100,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 2 / 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        child: Text("NO MORE SLOTS",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        child: Text(
                            "We have run out of slots for the time being. Come back again later!",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (mounted) {
                            Navigator.of(context).popUntil((_) =>
                                navigationCount++ >=
                                2); //! This is not an elegant solution. DO change in the future.
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 15 / 100,
                          child: Center(child: Text('Confirm')),
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }

  showEnterNumOfBottlesDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    TextEditingController smallController = TextEditingController();
    TextEditingController bigController = TextEditingController();
    TextEditingController otherController = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
            height: MediaQuery.of(context).size.height * 50 / 100,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 2 / 100),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 60 / 100,
                          child: Text("Estimated number of bottles:",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 60 / 100,
                          child: Text(
                              "Please provide an estimate of the number of bottles you will be recycling:",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.normal)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 25 / 100,
                          child: Column(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      60 /
                                      100,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                2.5 /
                                                100,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1 /
                                                100),
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                15 /
                                                100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Small: ",
                                                ),
                                                Text(
                                                  "(500ml)",
                                                ),
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                35 /
                                                100,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: smallController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Cannot be empty';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      60 /
                                      100,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                2.5 /
                                                100,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1 /
                                                100),
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                15 /
                                                100,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Big: ",
                                                ),
                                                Text(
                                                  "(1.5L)",
                                                ),
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                35 /
                                                100,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: bigController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Cannot be empty';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    60 /
                                    100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              2.5 /
                                              100,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1 /
                                              100),
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              15 /
                                              100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Others: ",
                                              ),
                                              Text(
                                                "",
                                              ),
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          35 /
                                          100,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: otherController,
                                        validator: (value) {
                                          // if (value == null || value.isEmpty) {
                                          //   return 'Cannot be empty';
                                          // }
                                          // return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    15 /
                                    100,
                                child: Center(
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 10 / 100,
                            ),
                            ElevatedButton(
                              onPressed: hasSelected()
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        String smallNumInput =
                                            smallController.text;
                                        String bigNumInput = bigController.text;
                                        String otherNumInput =
                                            otherController.text;
                                        bool isMoreThan25 =
                                            double.parse(smallNumInput) +
                                                    double.parse(bigNumInput) >=
                                                25;
                                        bool isValidInput = isInteger(
                                                double.parse(smallNumInput)) &&
                                            isInteger(
                                                double.parse(bigNumInput)) &&
                                            isMoreThan25;
                                        if (!isValidInput) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please enter a whole number that is 25 or more.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          return;
                                        }
                                        TimeslotModel timeslot =
                                            timeslotController.availTimeslots[
                                                _selectedAvailTimeslot!];
                                        EasyLoading.show(
                                            maskType: EasyLoadingMaskType.black,
                                            status: "Loading...");
                                        var res = await timeslotController
                                            .bookTimeslot(timeslot,
                                                auth.user.value!.address);

                                        if (res != null) {
                                          var collectorId =
                                              res['message']['collector'];
                                          var result = await txnController
                                              .createTxn(
                                                  auth.user.value!.id,
                                                  collectorId,
                                                  auth.user.value!.address,
                                                  auth.user.value!
                                                      .addressDetails,
                                                  timeslot.time,
                                                  {
                                                'small': smallNumInput,
                                                'big': bigNumInput,
                                                'other': otherNumInput,
                                              });
                                        }

                                        EasyLoading.dismiss();
                                        if (mounted) {
                                          // Navigator.pop(
                                          //     context);
                                          Navigator.of(context).popUntil((_) =>
                                              navigationCount++ >=
                                              3); //! This is not an elegant solution. DO change in the future.
                                        }
                                      }
                                    }
                                  : null,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    15 /
                                    100,
                                child: Center(child: Text('Ok')),
                              ),
                            ),
                          ],
                        )
                      ]),
                ))),
      ),
    );
  }
}

bool isInteger(num value) => value is int || value == value.roundToDouble();
