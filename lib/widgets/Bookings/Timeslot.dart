import 'package:flutter/material.dart';

class Timeslot extends StatelessWidget {
  const Timeslot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   color: Color.fromARGB(216, 255, 255, 255),
        //   borderRadius: BorderRadius.circular(15),
        //   // border: Border.all(
        //   //   width: 1,
        //   //   color: Theme.of(context).primaryColor,
        //   //   style: BorderStyle.solid,
        //   // ),
        // ),
        child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {},
      child: Center(
          child: Text(
        "09: 30 am",
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
      )),
    ));
  }
}
