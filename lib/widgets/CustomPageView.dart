import 'dart:ui';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  CustomPageView(
      {Key? key,
      required this.pageController,
      required List<Widget> navScreens,
      required this.onPageChanged})
      : _navScreens = navScreens,
        super(key: key);

  final List<Widget> _navScreens;
  PageController pageController;
  Function onPageChanged;

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"))),
        child: SafeArea(
            child: Container(
          color: HexColor("E2F6FF").withOpacity(0.35),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
              child: PageView(
                controller: widget.pageController,
                onPageChanged: (index) {
                  widget.onPageChanged(index);
                },
                children: widget._navScreens,
              ),
            ),
          ),
        )));
  }
}
