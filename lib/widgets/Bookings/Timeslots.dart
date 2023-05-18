import 'package:flutter/material.dart';
import 'package:restart/controllers/TimeslotController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeSlots extends StatefulWidget {
  TimeSlots(
      {Key? key,
      required this.selectedDate,
      required this.selectTimeslot,
      required this.value,
      required this.selectedAvailTimeslot})
      : super(key: key);

  Function selectTimeslot;
  DateTime? selectedDate;
  int? value;
  int? selectedAvailTimeslot;
  // int totalTimeslots =
  //     30; //!Could have a static max number of availTimeslots so each page looks the same
  List<int> timeSlotRange = [0, 48];
  @override
  State<TimeSlots> createState() => _TimeSlotsState();
}

class _TimeSlotsState extends State<TimeSlots> {
  TimeslotController timeslotController = Get.find();
  late DateTime startHour;
  late DateTime endHour;
  List<int> availableTimeslots = [];

  Duration period = Duration(minutes: 30);
  @override
  void initState() {
    startHour = DateTime(widget.selectedDate!.year, widget.selectedDate!.month,
            widget.selectedDate!.day, 6, 30)
        .toLocal();
    endHour = DateTime(widget.selectedDate!.year, widget.selectedDate!.month,
            widget.selectedDate!.day, 23, 30)
        .toLocal();
    getDateTimesBetween(start: startHour, end: endHour);
    super.initState();
  }

  @override
  void didUpdateWidget(old) {
    startHour = DateTime(widget.selectedDate!.year, widget.selectedDate!.month,
            widget.selectedDate!.day, 6, 30)
        .toLocal();
    endHour = DateTime(widget.selectedDate!.year, widget.selectedDate!.month,
            widget.selectedDate!.day, 24, 0)
        .toLocal();
    availableTimeslots = [];
    getDateTimesBetween(start: startHour, end: endHour);
    super.didUpdateWidget(old);
  }

  int getNumberOfTimeslots() {
    int i = 1;
    DateTime current = startHour;
    while (current.isBefore(endHour)) {
      i++;
      current = current.add(period);
    }
    return i;
  }

  void getDateTimesBetween({
    required DateTime start,
    required DateTime end,
  }) {
    int index = 0;
    DateTime current = start;
    List<DateTime> listOfTimings = List.generate(
        timeslotController.availTimeslots.length,
        (index) => timeslotController.availTimeslots[index].time.toLocal());
    // print(listOfTimings);
    while (current.isBefore(end)) {
      // print(current.toLocal());
      if (listOfTimings.contains(current)) {
        availableTimeslots.add(index);
      }
      index++;
      current = current.add(period);
    }
    // print(availableTimeslots);
  }

  DateTime getTimeBasedOnIndex(int i) {
    Duration difference = period * i;
    return startHour.add(difference);
  }

  int getAvailTimeslotIndexFromVal() {
    int tsIndex = widget.value!;
    DateTime time = getTimeBasedOnIndex(tsIndex);

    return timeslotController.availTimeslots
        .indexWhere((elem) => elem.time == time);
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.getNumberOfTimeslots() < 1) {
    //   return Center(child: Container(child: Text("No Timeslots Available")));
    // }
    return GridView.builder(
      itemCount: getNumberOfTimeslots(),
      // itemCount: widget.getNumberOfTimeslots(),
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 2 / 100,
        horizontal: MediaQuery.of(context).size.width * 4 / 100,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2.4,
        mainAxisSpacing: MediaQuery.of(context).size.height * 1.5 / 100,
        crossAxisSpacing: MediaQuery.of(context).size.width * 2 / 100,
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: ChoiceChip(
            clipBehavior: Clip.none,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 4 / 100,
                vertical: MediaQuery.of(context).size.height * 1.5 / 100),
            backgroundColor: Colors.white,
            selectedColor: Theme.of(context).primaryColor,
            disabledColor: Colors.white.withOpacity(0.35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // side: widget.availableTimeslots.contains(index)
            //     ? null
            //     : BorderSide(
            //         width: 1,
            //         color: Theme.of(context).primaryColor.withOpacity(0.3)),
            label: IntrinsicHeight(
              child: Container(
                // color: Colors.black,
                // padding: EdgeInsets.symmetric(vertical: 10),
                alignment: AlignmentDirectional.center,
                child: Text(
                  DateFormat.Hm().format(getTimeBasedOnIndex(index)).toString(),
                  style: TextStyle(
                      color: index == widget.value
                          ? Colors.white
                          : availableTimeslots.contains(index)
                              ? Theme.of(context).primaryColor
                              : const Color.fromARGB(171, 0, 0, 0)),
                ),
              ),
            ),
            selected: widget.value == index,
            onSelected: availableTimeslots.contains(index)
                ? (bool selected) {
                    setState(() {
                      widget.value = selected ? index : null;
                      print(widget.value);
                      widget.selectTimeslot(widget.selectedDate, widget.value,
                          getAvailTimeslotIndexFromVal());
                    });
                  }
                : null,
          ),
        );
      },
    );
  }
}
