import 'package:flutter/material.dart';
import 'package:testapp/views/seller_pages/seller_map.dart';
import 'package:testapp/views/seller_pages/seller_profile.dart';
import 'package:testapp/views/seller_pages/seller_requests.dart';

class SellerPageBuilder extends StatefulWidget {
  const SellerPageBuilder({Key? key}) : super(key: key);

  @override
  State<SellerPageBuilder> createState() => _SellerPageBuilderState();
}

class _SellerPageBuilderState extends State<SellerPageBuilder> {
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

const _widgetList = <Widget>[
  SellerMap(),
  SellerRequests(),
  SellerProfile(),
];

const _navyItems = <NavigationDestination>[
  NavigationDestination(icon: Icon(Icons.map), label: 'orders'),
  NavigationDestination(icon: Icon(Icons.shop), label: 'Requests'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'settings'),
];