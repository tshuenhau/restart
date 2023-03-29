import 'package:flutter/material.dart';
import 'package:restart/App.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/LoginScreen.dart';
import 'package:restart/screens/SplashScreen.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  AuthController auth = Get.put(AuthController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(82, 101, 203, 1);

    return OverlaySupport(
      child: GetMaterialApp(
        title: 'RE:Start',
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
        home: Obx(() => auth.state.value == AuthState.UNKNOWN
            ? const SplashPage()
            : auth.state.value == AuthState.LOGGEDIN
                ? const App()
                : const LoginScreen()),
      ),
    );
  }
}
