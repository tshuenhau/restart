import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/widgets/layout/Background.dart';
import 'package:restart/widgets/Bookings/Timeslots.dart';
import 'package:restart/widgets/GlassCards/GlassCard_headerfooter.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/Bookings/Timeslot.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart/models/TimeslotModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddBookingScreen extends StatefulWidget {
  const AddBookingScreen({Key? key}) : super(key: key);

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  @override
  initState() {
    print("ADD BOOKING SCREEN");
    super.initState();
    timeslotController.getTimeslots();
  }

  @override
  dispose() {
    print('disposing add booking screen');
    super.dispose();
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
                  Text("Getting time slots"),
                ],
              )),
            ) //TODO: Create a loading page/widget or smth
          : CustomScaffold(
              body: GlassCard_headerfooter(
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
                                  MediaQuery.of(context).size.width * 15 / 100,
                              child: Center(child: Text("Back")))),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 10 / 100),
                      ElevatedButton(
                          onPressed: hasSelected()
                              ? () async {
                                  TimeslotModel timeslot = timeslotController
                                      .availTimeslots[_selectedAvailTimeslot!];
                                  print("SELECTED AVAIL TIMESLOT " +
                                      _selectedAvailTimeslot.toString());
                                  EasyLoading.show(status: "loading");
                                  var result = await txnController.createTxn(
                                      auth.user.value!.id,
                                      auth.user.value!.address,
                                      timeslot.time);
                                  print("ADDRESS " +
                                      auth.user.value!.address.toString());
                                  var res =
                                      await timeslotController.bookTimeslot(
                                    timeslot,
                                    auth.user.value!.address,
                                  );
                                  EasyLoading.dismiss();
                                  Navigator.pop(context);
                                }
                              : null,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 15 / 100,
                            child: Center(child: Text("Confirm")),
                          ))
                    ]),
                height: MediaQuery.of(context).size.height * 90 / 100,
                body: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 1 / 100),
                    Container(
                        width: MediaQuery.of(context).size.width * 85 / 100,
                        // height: MediaQuery.of(context).size.height * 20 / 100,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(213, 255, 255, 255),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            width: 0,
                            color: Theme.of(context).primaryColor,
                            style: BorderStyle.none,
                          ),
                        ),
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).size.height * 1.5 / 100),
                        child: CalendarTimeline(
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().weekday == DateTime.sunday
                              ? DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1)
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
                        height: MediaQuery.of(context).size.height * 0 / 100),
                    Expanded(
                      child: TimeSlots(
                          selectedDate: _selectedDate,
                          selectTimeslot: _selectTimeslot,
                          value: _selectedTimeslot,
                          selectedAvailTimeslot: _selectedAvailTimeslot),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
