import 'package:flutter/material.dart';
import 'package:restart/screens/CustomScaffold.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("TF");
    return CustomScaffold(
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: MediaQuery.of(context).size.height * 5 / 100),
            Text("Server waking up..."),
          ],
        ),
      )),
    );
  }
}
