import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/driver_pages/driver_requests_state/driver_requests_active.dart';
import 'package:testapp/views/driver_pages/driver_requests_state/driver_requests_inctive.dart';

class DriverRequestsView extends StatefulWidget {
  const DriverRequestsView({Key? key}) : super(key: key);

  @override
  State<DriverRequestsView> createState() => _DriverRequestsViewState();
}

class _DriverRequestsViewState extends State<DriverRequestsView> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
        title: bigText(
          text: 'My Requests',
          color: color5,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info_outline_rounded),
          color: color5,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_outlined),
            color: color5,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: CloudService().getDriverRequests(userId: userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                if (!snapshot.data!.docs.isEmpty) {
                  final docs = snapshot.data!.docs;
                  return DriverRequestsInactive(snapshot: docs);
                } else {
                  return const DriverRequestsList();
                }
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
