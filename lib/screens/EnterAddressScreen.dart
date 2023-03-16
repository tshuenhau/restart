import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EnterAddressScreen extends StatelessWidget {
  EnterAddressScreen({required this.onPressed, Key? key}) : super(key: key);
  void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Put the google places api thingy here boi"),
      ElevatedButton(onPressed: onPressed, child: Text("Back"))
    ]));
  }
}
