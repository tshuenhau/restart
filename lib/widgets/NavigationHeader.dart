import 'package:flutter/material.dart';

class NavigationHeader extends StatelessWidget {
  NavigationHeader({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: const Icon(Icons.arrow_back)),
      Text(title),
      IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, color: Colors.transparent)),
    ]);
  }
}
