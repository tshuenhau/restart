import 'package:flutter/material.dart';
import 'package:restart/widgets/layout/Background.dart';

class CustomScaffold extends StatelessWidget {
  CustomScaffold({required this.body, Key? key}) : super(key: key);
  late Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Background(
            child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0 / 100),
                    child: body))));
  }
}
