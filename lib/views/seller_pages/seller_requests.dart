import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

class SellerRequests extends StatefulWidget {
  const SellerRequests({Key? key}) : super(key: key);

  @override
  State<SellerRequests> createState() => _SellerRequestsState();
}

class _SellerRequestsState extends State<SellerRequests> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color3,
        elevation: 0,
        centerTitle: true,
        title: GenericText(
          text: 'My Requests',
          color: color2,
        ),
      ),
      drawer: Drawer(
        elevation: 16,
        child: Container(color: color3),
      ),
      body: FutureBuilder(
        future: DriverCloud().sellerRequestsIsEmpty(userId: userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case (ConnectionState.waiting):
              return const Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              return sellerRequestsDisplay(
                  isTrue: snapshot.data, userId: userId);

            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget sellerRequestsDisplay({required bool isTrue, required String userId}) {
    if (isTrue) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenericText(
                text: 'There are no requests at the moment!', color: color3),
            Lottie.asset('assets/no requests.json'),
            const SizedBox(height: 50),
            GenericButton(
                primaryColor: color3,
                pressColor: color2,
                text: 'Add a request',
                onPressed: () {
                  Navigator.of(context).pushNamed(requests);
                },
                textColor: color2),
          ],
        ),
      );
    } else {
      return const Center(child: Text('hi'));
    }
  }
}
