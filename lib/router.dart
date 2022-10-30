import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/driver_pages/page_builder_driver.dart';
import 'package:testapp/views/seller_pages/page_builder_seller.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({Key? key}) : super(key: key);

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: CloudService().isDriver(userId: userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                        child: Lottie.asset('assets/animation.json',
                            width: MediaQuery.of(context).size.height),
                      ),
                      GenericText3(text: 'Welcome back', color: color3),
                      GenericText(
                          text: "This will only take a second...",
                          color: color5),
                    ],
                  ),
                ),
              );
            case ConnectionState.done:
              if (snapshot.data) {
                return const DriverPageBuilder();
              } else {
                return const SellerPageBuilder();
              }
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
