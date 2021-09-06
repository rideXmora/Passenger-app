import 'package:flutter/material.dart';
import 'package:passenger_app/pages/home_screen.dart';
import 'package:passenger_app/pages/profile_screen.dart';
import 'package:passenger_app/pages/trip_history_screen.dart';

final List<Widget> pages = [
  ProfileScreen(),
  HomeScreen(),
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
