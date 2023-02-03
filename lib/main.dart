import 'package:flutter/material.dart';
import 'package:restart/App.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(82, 101, 203, 1);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(82, 101, 203, 1),
            // disabledBackgroundColor: Colors.white
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 1.5, color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: primaryColor,
          backgroundColor: Colors.transparent,
        )),
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}
