import 'dart:ui';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:restart/screens/CommunityScreen.dart';
import 'package:restart/screens/HomeScreen.dart';
import 'package:restart/screens/MissionsScreen.dart';
import 'package:restart/screens/RewardScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restart/widgets/layout/Background.dart';
import 'package:restart/widgets/layout/CustomBottomNavigationBar.dart';
import 'package:restart/widgets/layout/CustomPageView.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/TxnController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:restart/models/PushNotification.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_core/firebase_core.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TxnController txnController = Get.put(TxnController());
  PushNotification? _notificationInfo;

  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        print('message received!');
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title ?? notification.dataTitle ?? ""),
            // leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle:
                Text(_notificationInfo!.body ?? notification.dataBody ?? ""),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    print("WTF");
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  // ! if going from page 2 -> 0, it will prnint 2, 1, 0 since it animates through the middle page
  late PageController _pageController;
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _navScreens = [
    const HomeScreen(),
    MissionsScreen(),
    const CommunityScreen(),
    // const RewardScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
      });
    });
    registerNotification();
    checkForInitialMessage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      extendBody: true,
      body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            content: Text('Tap back again to leave'),
          ),
          child: Background(
            child:
                // color: HexColor("E2F6FF").withOpacity(0.35),
                CustomPageView(
              navScreens: _navScreens,
              pageController: _pageController,
              onPageChanged: _onPageChanged,
            ),
          )),
      bottomNavigationBar: CustomBottomNavigationBar(
        pageController: _pageController,
        selectedIndex: _selectedIndex,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
