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
    return GridView.builder(
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
        return ChoiceChip(
          clipBehavior: Clip.none,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 4 / 100,
              vertical: MediaQuery.of(context).size.height * 1.5 / 100),
          backgroundColor: Colors.white,
          selectedColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                        : Theme.of(context).primaryColor),
              ),
            ),
          ),
          selected: widget.value == index,
          onSelected: (bool selected) {
            setState(() {
              widget.value = selected ? index : null;
              widget.selectTimeslot(widget.selectedDate, widget.value);
            });
          },
        );
      },
    );
  }
}
