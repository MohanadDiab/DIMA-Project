import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
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
        body: SizedBox.expand(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: _widgetList),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: _navyItems,
        ),
      ),
    );
  }
}

final _widgetList = <Widget>[
  DriverMap(),
  const DriverRequestsView(),
  const ChatPage(),
  const DriverProfile(),
];

final _navyItems = <BottomNavyBarItem>[
  BottomNavyBarItem(title: Text('Orders'), icon: Icon(Icons.map)),
  BottomNavyBarItem(title: Text('Requests'), icon: Icon(Icons.shop)),
  BottomNavyBarItem(title: Text('Chats'), icon: Icon(Icons.chat_bubble)),
  BottomNavyBarItem(title: Text('Settings'), icon: Icon(Icons.settings)),
];
