import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restart/widgets/Bookings/Timeslot.dart';

class TimeSlots extends StatefulWidget {
  TimeSlots(
      {Key? key,
      required this.selectedDate,
      required this.selectTimeslot,
      required this.value})
      : super(key: key);

  Function selectTimeslot;
  DateTime? selectedDate;
  int? value;

  List<int> availableTimeslots = [1, 3, 4, 5, 6, 7, 8, 9, 11, 15];
  // int totalTimeslots =
  //     30; //!Could have a static max number of timeslots so each page looks the same
  List<int> timeSlotRange = [0, 25];

  int getNumberOfTimeslots() {
    return timeSlotRange.fold(0, max);
  }

  @override
  State<TimeSlots> createState() => _TimeSlotsState();
}

class _TimeSlotsState extends State<TimeSlots> {
  @override
  void didUpdateWidget(old) {
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.getNumberOfTimeslots() < 1) {
    //   return Center(child: Container(child: Text("No Timeslots Available")));
    // }
    return GridView.builder(
      itemCount: widget.getNumberOfTimeslots(),
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
                  'Slot $index',
                  style: TextStyle(
                      color: index == widget.value
                          ? Colors.white
                          : widget.availableTimeslots.contains(index)
                              ? Theme.of(context).primaryColor
                              : Color.fromARGB(171, 0, 0, 0)),
                ),
              ),
            ),
            selected: widget.value == index,
            onSelected: widget.availableTimeslots.contains(index)
                ? (bool selected) {
                    setState(() {
                      widget.value = selected ? index : null;
                      widget.selectTimeslot(widget.selectedDate, widget.value);
                    });
                  }
                : null,
          ),
        );
      },
    );
  }
}
