import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:restart/App.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/LoginScreen.dart';
import 'package:restart/screens/SetDetailsScreen.dart';
import 'package:restart/screens/SplashScreen.dart';
import 'controllers/TxnController.dart';
import 'controllers/UserController.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  var androidInit = const AndroidInitializationSettings('@app_icon');
  var iosInit = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  var initSetting = InitializationSettings(android: androidInit, iOS: iosInit);

  fltNotification.initialize(initSetting);
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    '1',
    're:start',
    channelDescription: 'sole channel for app',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  fltNotification.show(message.data.hashCode, message.data['title'],
      message.data['body'], notificationDetails);
  print(message.data['title']);
  print(message.data['body']);

  if (message.data['isTxnComplete'] == "true") {
    await getTxnsAndMissions(isBg: true);
  }
}

Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  var androidInit = const AndroidInitializationSettings('@app_icon');
  var iosInit = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  var initSetting = InitializationSettings(android: androidInit, iOS: iosInit);
  fltNotification.initialize(initSetting);
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    '1',
    're:start',
    channelDescription: 'sole channel for app',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  print(message.data['title']);
  print(message.data['body']);
  fltNotification.show(message.data.hashCode, message.data['title'],
      message.data['body'], notificationDetails);

  print('is txn complete ' + message.data["isTxnComplete"].toString());
  if (message.data['isTxnComplete'] == "true") {
    EasyLoading.show(status: "Loading...");
    await getTxnsAndMissions(isBg: false);
    EasyLoading.dismiss();
  }
}

FlutterLocalNotificationsPlugin fltNotification =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  void configLoading() {}
  await GetStorage.init();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  print('requesting android persmissions');
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.requestPermission();

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         IOSFlutterLocalNotificationsPlugin>()
  //     ?.requestPermissions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  AuthController auth = Get.put(AuthController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(82, 101, 203, 1);
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..progressColor = Theme.of(context).primaryColor
      ..backgroundColor = Colors.white
      ..indicatorColor = Theme.of(context).primaryColor
      ..textColor = Theme.of(context).primaryColor
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    return OverlaySupport(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        title: 'RE:Start',
        theme: ThemeData(
          fontFamily: "AvenirLTStd",
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
                ? auth.isUserInfoComplete()
                    ? const App()
                    : SetDetailsScreen()
                : LoginScreen()),
      ),
    );
  }
}

getTxnsAndMissions({required bool isBg}) async {
  AuthController auth;
  TxnController txnController;
  UserController user;
  if (!isBg) {
    auth = Get.put(AuthController());
    print('user: ' + auth.user.value.toString());
    txnController = Get.put(TxnController());
    user = Get.put(UserController());
    await txnController.getTxns();
    print('txn works');
    await user.getMissions();
    print('mission works');
    await user.getUserProfile();
    print('user works');
  } else {
    print("IS BG");
    final box = GetStorage();
    await box.write('isRefresh', true);
    print(box.read('isRefresh'));
  }
}
