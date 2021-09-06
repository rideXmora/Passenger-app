import 'package:flutter/material.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/pages/home_screen.dart';
import 'package:passenger_app/pages/profile_screen.dart';
import 'package:passenger_app/pages/trip_history_screen.dart';

class BottomNavHandler extends StatefulWidget {
  @override
  _BottomNavHandlerState createState() => _BottomNavHandlerState();
}

class _BottomNavHandlerState extends State<BottomNavHandler> {
  var bottomBarIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ProfileScreen(),
      HomeScreen(),
      TripHistoryScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: pages[bottomBarIndex],
      bottomNavigationBar: Container(
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(17),
            topRight: Radius.circular(17),
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: false,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: primaryColorDark,
            currentIndex: bottomBarIndex,
            onTap: (index) async {
              setState(() {
                bottomBarIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: primaryColorWhite,
                  size: 30,
                ),
                label: "Profile",
                activeIcon: Container(
                  decoration: BoxDecoration(
                    color: primaryColorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.5),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: primaryColorBlack,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                  color: primaryColorWhite,
                  size: 30,
                ),
                label: "Home",
                activeIcon: Container(
                  decoration: BoxDecoration(
                    color: primaryColorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.5),
                    child: Center(
                      child: Icon(
                        Icons.home_rounded,
                        color: primaryColorBlack,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book_rounded,
                  color: primaryColorWhite,
                  size: 30,
                ),
                label: "History",
                activeIcon: Container(
                  decoration: BoxDecoration(
                    color: primaryColorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.5),
                    child: Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: primaryColorBlack,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
