import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/driver_pages/page_builder_driver.dart';
import 'package:testapp/views/seller_pages/page_builder_seller.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    initializeAppUI();
  }

  void initializeAppUI() async {
    Future.delayed(const Duration(seconds: 2));
    final isDriver = await CloudService().isDriver(userId: userId);
    if (isDriver) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const DriverPageBuilder(),
          ),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const SellerPageBuilder(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(child: Image.asset('assets/logo.png')),
    );
  }
}
