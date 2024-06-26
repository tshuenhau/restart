import 'dart:ui';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/background9.png"))),
        child: Container(
          color: Color.fromARGB(73, 55, 129, 190),
          // Color.fromARGB(255, 55, 129, 190)
          child: SafeArea(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: child,
              ),
            ),
          ),
        ));
  }
}
