import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:restart/App.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar(
      {Key? key,
      required this.fullScreenKey,
      required this.pageController,
      required this.selectedIndex,
      required this.bottomNavigationMissionsKey})
      : super(key: key);
  late PageController pageController;
  late Key bottomNavigationMissionsKey;
  int selectedIndex = 0;
  GlobalKey fullScreenKey;
  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  //int _selectedIndex = 0;
  double roundedRadius = 20;

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      widget.pageController.animateToPage(index,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(roundedRadius),
        topRight: Radius.circular(roundedRadius),
      ),
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // backgroundBlendMode: BlendMode.clear,

              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 2),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(roundedRadius),
                    topRight: Radius.circular(roundedRadius),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 8 / 100,
                    child: BottomNavigationBar(
                      elevation: 0,
                      iconSize: MediaQuery.of(context).size.height * 3 / 100,
                      selectedFontSize:
                          MediaQuery.of(context).size.height * 1.6 / 100,
                      unselectedFontSize:
                          MediaQuery.of(context).size.height * 1.5 / 100,
                      backgroundColor: Colors.white,
                      selectedItemColor: Theme.of(context).primaryColor,
                      unselectedItemColor: Theme.of(context).hintColor,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.emoji_events),
                          label: 'Achievements',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.map),
                          label: 'Missions',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.people),
                          label: 'Community',
                        ),
                      ],
                      currentIndex: widget.selectedIndex,
                      onTap: _onItemTapped,
                    ),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 8 / 100,
                    width: MediaQuery.of(context).size.width * 100,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 1 / 100,
                            ),
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 20 / 100,
                              height:
                                  MediaQuery.of(context).size.height * 6 / 100,
                            ),
                          ),
                        )),
                        Expanded(
                            child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 1 / 100,
                            ),
                            child: SizedBox(
                              key: widget.bottomNavigationMissionsKey,
                              width:
                                  MediaQuery.of(context).size.width * 20 / 100,
                              height:
                                  MediaQuery.of(context).size.height * 6 / 100,
                            ),
                          ),
                        )),
                        Expanded(
                            child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 1 / 100,
                            ),
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 20 / 100,
                              height:
                                  MediaQuery.of(context).size.height * 6 / 100,
                            ),
                          ),
                        )),
                      ],
                    )),
                Positioned(
                    key: widget.fullScreenKey,
                    right: MediaQuery.of(context).size.width / 2,
                    left: MediaQuery.of(context).size.width / 2,
                    bottom: -MediaQuery.of(context).size.height * 5 / 100,
                    child:
                        Container(width: 10, height: 10, color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
