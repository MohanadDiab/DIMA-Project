import 'package:flutter/material.dart';
import 'package:testapp/views/driver_pages/driver_chat.dart';
import 'package:testapp/views/maps/driver_map.dart';
import 'package:testapp/views/driver_pages/driver_profile.dart';
import 'package:testapp/views/driver_pages/driver_requests.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  int _currentIndex = 0;

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
    return SafeArea(
      child: Scaffold(
        body: _widgetList[_currentIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.blueGrey.shade100,
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
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
      ),
    );
  }
}

final _widgetList = <Widget>[
  DriverMap(),
  DriverRequestsView(),
  ChatPage(),
  DriverProfile(),
];

final _navyItems = <NavigationDestination>[
  NavigationDestination(icon: Icon(Icons.map), label: 'orders'),
  NavigationDestination(icon: Icon(Icons.shop), label: 'Requests'),
  NavigationDestination(icon: Icon(Icons.chat_bubble), label: 'chats'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'settings'),
];
