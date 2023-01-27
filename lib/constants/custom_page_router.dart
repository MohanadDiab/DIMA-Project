import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';

class MyRoute extends MaterialPageRoute {
  MyRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

final navyItems = <NavigationDestination>[
  NavigationDestination(
      icon: Icon(
        Icons.map,
        color: color5,
      ),
      label: 'orders'),
  NavigationDestination(
      icon: Icon(
        Icons.shop,
        color: color5,
      ),
      label: 'Requests'),
  NavigationDestination(
      icon: Icon(
        Icons.person,
        color: color5,
      ),
      label: 'Profile'),
];
