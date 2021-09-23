import 'package:flutter/material.dart';
import 'package:passenger_app/pages/home/home_screens.dart';
import 'package:passenger_app/pages/profile/pages/profile_screen.dart';
import 'package:passenger_app/pages/tirp_history/pages/trip_history_screen.dart';

final List<Widget> pages = [
  ProfileScreen(),
  HomeScreens(),
  TripHistoryScreen(),
];

Route createRoute(index) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pages[index],
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
