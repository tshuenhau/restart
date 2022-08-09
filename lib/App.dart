import 'dart:ui';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:restart/screens/CommunityScreen.dart';
import 'package:restart/screens/HomeScreen.dart';
import 'package:restart/screens/RewardScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restart/widgets/CustomBottomNavigationBar.dart';
import 'package:restart/widgets/CustomPageView.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
    const CommunityScreen(),
    const RewardScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: CustomPageView(
          navScreens: _navScreens,
          pageController: _pageController,
          onPageChanged: _onPageChanged,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        pageController: _pageController,
        selectedIndex: _selectedIndex,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
