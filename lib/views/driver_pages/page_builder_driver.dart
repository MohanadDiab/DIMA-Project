import 'package:flutter/material.dart';
import 'package:testapp/views/maps/driver_map.dart';
import 'package:testapp/views/driver_pages/driver_profile.dart';
import 'package:testapp/views/driver_pages/driver_requests.dart';

class DriverPageBuilder extends StatefulWidget {
  const DriverPageBuilder({Key? key}) : super(key: key);

  @override
  State<DriverPageBuilder> createState() => _DriverPageBuilderState();
}

class _DriverPageBuilderState extends State<DriverPageBuilder> {
  int _currentIndex = 1;

  late PageController _pageController;

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
      body: _widgetList[_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          elevation: 50,
          backgroundColor: Colors.white,
          indicatorColor: Colors.grey[200],
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(
            () {
              _currentIndex = index;
            },
          ),
          destinations: _navyItems,
        ),
      ),
    );
  }
}

const _widgetList = <Widget>[
  DriverMap(),
  DriverRequestsView(),
  DriverProfile(),
];

const _navyItems = <NavigationDestination>[
  NavigationDestination(icon: Icon(Icons.map), label: 'orders'),
  NavigationDestination(icon: Icon(Icons.shop), label: 'Requests'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'settings'),
];
