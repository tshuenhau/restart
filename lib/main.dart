import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:restart/App.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/EditProfileScreen.dart';
import 'package:restart/screens/LoginScreen.dart';
import 'package:restart/screens/SetDetailsScreen.dart';
import 'package:restart/screens/SplashScreen.dart';
import 'package:restart/widgets/CompleteMissionDialog.dart';
import 'package:restart/widgets/EditProfileField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'controllers/TxnController.dart';
import 'controllers/UserController.dart';
import 'firebase_options.dart';
import 'models/MissionModel.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("background message received!");
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

  await processBackgroundMessage(message, notificationDetails);

  fltNotification.show(message.data.hashCode, message.data['title'],
      message.data['body'], notificationDetails);
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
  await processForegroundMessage(message, notificationDetails);
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
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // print('requesting android persmissions');
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
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance
        .setAnalyticsCollectionEnabled(kDebugMode ? false : true);

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
        navigatorObservers: <NavigatorObserver>[observer],
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
        home: UpgradeAlert(
          upgrader: Upgrader(
              dialogStyle: Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material),
          child: Obx(() => auth.state.value == AuthState.UNKNOWN
              ? const SplashPage()
              : auth.state.value == AuthState.LOGGEDIN
                  ? auth.isUserInfoComplete()
                      ? const App()
                      : SetDetailsScreen()
                  : LoginScreen()),
        ),
      ),
    );
  }
}

getActionFromNotification({required bool isBg, required double weight}) async {
  if (isBg) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('set weight success? ' +
        (await prefs.setDouble('weight', weight).toString()));
  } else {
    final box = GetStorage();
    await box.write('weight', weight);
  }
}

showLevelUpNotification(
    {required bool isBg, required double weight, required double exp}) async {
  if (isBg) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('set weight success? ' +
        (await prefs.setDouble('weight', weight).toString()));
  } else {
    final box = GetStorage();
    await box.write('weight', weight);
  }
}

completeMissionAction(
    {required bool isBg,
    required MissionModel mission,
    required double weight_collected}) async {
  if (isBg) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'mission',
        json.encode({
          'title': mission.title,
          'body': mission.body,
          'weight': mission.weight,
          'exp': mission.exp,
          'weight_collected': weight_collected
        }));
  } else {
    final box = GetStorage();

    await box.write(
        'mission',
        json.encode({
          'title': mission.title,
          'body': mission.body,
          'weight': mission.weight,
          'exp': mission.exp,
          'weight_collected': weight_collected
        }));
  }
}

noCompleteMissionAction(
    {required bool isBg,
    required MissionModel mission,
    required double weight_collected}) async {
  if (isBg) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs
        .setString(
            'no-mission',
            json.encode({
              'weight_collected': weight_collected,
              'nearest_mission': {
                'title': mission.title,
                'body': mission.body,
                'weight': mission.weight,
                'exp': mission.exp,
              }
            }))
        .toString();
  } else {
    final box = GetStorage();
    await box.write(
        'no-mission',
        json.encode({
          'weight_collected': weight_collected,
          'nearest_mission': {
            'title': mission.title,
            'body': mission.body,
            'weight': mission.weight,
            'exp': mission.exp,
          }
        }));
  }
}

processBackgroundMessage(
    RemoteMessage message, NotificationDetails notificationDetails) async {
  if (message.data['isTxnComplete'] == "true") {
    double weight = double.parse(message.data['weight']);
    await getActionFromNotification(isBg: true, weight: weight);
  } else if (message.data['isCompleteMission'] == 'true') {
    print('complete mission!');
    var data = jsonDecode(message.data['mission']);
    MissionModel mission = MissionModel.fromJson(data);
    var weight_collected = double.parse(message.data['weight_collected']);
    await completeMissionAction(
        isBg: true, mission: mission, weight_collected: weight_collected);
  } else if (message.data['isCompleteMission'] == 'false') {
    var weight_collected = double.parse(message.data['weight_collected']);
    var data = jsonDecode(message.data['nearest_mission']);
    MissionModel mission = MissionModel.fromJson(data);
    await noCompleteMissionAction(
        isBg: true, mission: mission, weight_collected: weight_collected);
  }
}

processForegroundMessage(
    RemoteMessage message, NotificationDetails notificationDetails) async {
  print('processing foreground message');
  print(message.data);

  fltNotification.show(message.data.hashCode, message.data['title'],
      message.data['body'], notificationDetails);

  if (message.data['isTxnComplete'] == "true") {
    EasyLoading.show(status: "Loading...");
    double weight = double.parse(message.data['weight']);
    await getActionFromNotification(isBg: false, weight: weight);
    EasyLoading.dismiss();
  } else if (message.data['isCompleteMission'] == 'true') {
    EasyLoading.show(status: "Loading...");
    var data = jsonDecode(message.data['mission']);

    MissionModel mission = MissionModel.fromJson(data);
    double weight_collected = double.parse(message.data['weight_collected']);
    completeMissionAction(
        isBg: false, mission: mission, weight_collected: weight_collected);
    EasyLoading.dismiss();
  } else if (message.data['isCompleteMission'] == 'false') {
    EasyLoading.show(status: "Loading...");
    var data = jsonDecode(message.data['nearest_mission']);
    MissionModel mission = MissionModel.fromJson(data);
    double weight_collected = double.parse(message.data['weight_collected']);
    noCompleteMissionAction(
        isBg: false, mission: mission, weight_collected: weight_collected);

    EasyLoading.dismiss();
  }
}
