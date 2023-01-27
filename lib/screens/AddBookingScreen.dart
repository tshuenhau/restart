import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:restart/widgets/Background.dart';
import 'package:restart/widgets/GlassCards/GlassCard_headerfooter.dart';
import 'package:restart/widgets/NavigationHeader.dart';
import 'package:restart/widgets/Timeslot.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class AddBookingScreen extends StatefulWidget {
  const AddBookingScreen({Key? key}) : super(key: key);

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
            child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 2 / 100),
        child: GlassCard_headerfooter(
            header: NavigationHeader(title: "Book Collection"),
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
                          width: MediaQuery.of(context).size.width * 15 / 100,
                          child: Center(child: Text("Back")))),
                  SizedBox(width: MediaQuery.of(context).size.width * 10 / 100),
                  ElevatedButton(
                      onPressed: () {},
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 15 / 100,
                        child: Center(child: Text("Confirm")),
                      ))
                ]),
            height: MediaQuery.of(context).size.height * 90 / 100,
            body: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 1 / 100),
                Container(
                    width: MediaQuery.of(context).size.width * 85 / 100,
                    // height: MediaQuery.of(context).size.height * 20 / 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(213, 255, 255, 255),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        width: 0,
                        color: Theme.of(context).primaryColor,
                        style: BorderStyle.none,
                      ),
                    ),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 1.5 / 100),
                    // color: Color.fromARGB(54, 255, 255, 255),
                    child: CalendarTimeline(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year,
                          DateTime.now().month + 1, DateTime.now().day),
                      onDateSelected: (date) => print(date),
                      leftMargin: 20,
                      monthColor: Theme.of(context).primaryColor,
                      dayColor: Theme.of(context).primaryColor,
                      activeDayColor: Colors.white,
                      activeBackgroundDayColor: Theme.of(context).primaryColor,
                      dotsColor: Colors.white,
                      selectableDayPredicate: (date) =>
                          date.weekday != DateTime.sunday,
                      locale: 'en_ISO',
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0 / 100),
                Expanded(
                  child: GridView.count(
                    clipBehavior: Clip.antiAlias,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 2 / 100,
                      horizontal: MediaQuery.of(context).size.width * 4 / 100,
                    ),
                    crossAxisCount: 3,
                    childAspectRatio: 2.4,
                    mainAxisSpacing:
                        MediaQuery.of(context).size.height * 1.5 / 100,
                    crossAxisSpacing:
                        MediaQuery.of(context).size.width * 2 / 100,
                    children: [
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                      Timeslot(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    )));
  }
}
