import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:testapp/constants/customPageRouter.dart';
import 'package:testapp/views/maps/seller_map.dart';

import 'seller_profile.dart';
import 'seller_requests.dart';

class SellerPageBuilder extends StatefulWidget {
  const SellerPageBuilder({Key? key}) : super(key: key);

  @override
  State<SellerPageBuilder> createState() => _SellerPageBuilderState();
}

class _SellerPageBuilderState extends State<SellerPageBuilder> {
  int _currentIndex = 1;
  final pageController = PageController();
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => {pageController.jumpToPage(1)});
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < constraints.maxHeight) {
          return Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: _widgetList,
            ),
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
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
              ),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) => setState(
                  () {
                    print(index + 100);
                    pageController.jumpToPage(index);
                  },
                ),
                destinations: navyItems,
              ),
            ),
          );
        } else {
          return Scaffold(
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: _widgetList,
            ),
          );
        }
      },
    );
  }
}

const _widgetList = <Widget>[
  SellerMap(),
  SellerRequests(),
  SellerProfile(),
];
