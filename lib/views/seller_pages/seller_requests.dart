import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/seller_requests_states/request_assigned.dart';
import 'seller_requests_states/request_inactive.dart';
import 'seller_requests_states/requests_active.dart';
import 'seller_requests_states/requests_archived.dart';
import 'seller_requests_states/requests_empty.dart';

class SellerRequests extends StatefulWidget {
  const SellerRequests({Key? key}) : super(key: key);

  @override
  State<SellerRequests> createState() => _SellerRequestsState();
}

class _SellerRequestsState extends State<SellerRequests> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task,
                      color: color3,
                    ),
                    const SizedBox(width: 5),
                    GenericText(
                      text: 'Active',
                      color: color5,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.archive,
                      color: color3,
                    ),
                    const SizedBox(width: 5),
                    GenericText(
                      text: 'Archive',
                      color: color5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          title: BigText(
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
        body: const TabBarView(
          children: [
            SellerActiveRequests(),
            SellerArchivedRequests(),
          ],
        ),
      ),
    );
  }
}

class SellerActiveRequests extends StatefulWidget {
  const SellerActiveRequests({Key? key}) : super(key: key);

  @override
  State<SellerActiveRequests> createState() => _SellerActiveRequestsState();
}

class _SellerActiveRequestsState extends State<SellerActiveRequests> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  late bool isPublished;
  late bool isAssigned;
  late dynamic driver;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
        [
          CloudService().sellerIsPublished(userId: userId),
          CloudService().sellerIsAssigned(userId: userId),
          CloudService().sellerAssignedDriver(userId: userId),
        ],
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.waiting):
            return Container();
          case (ConnectionState.done):
            isPublished = snapshot.data[0];
            isAssigned = snapshot.data[1];
            driver = snapshot.data[2];
            return StreamBuilder(
              stream: CloudService().getSellerRequests(userId: userId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.active:
                    final docs = snapshot.data!.docs;

                    if (!snapshot.data!.docs.isNotEmpty) {
                      return const SellerRequestsIsEmpty();
                    } else if (isAssigned) {
                      return SellerRequestsAssigned(
                          snapshot: docs, driver: driver);
                    } else if (isPublished) {
                      return SellerRequestsActive(snapshot: docs);
                    } else {
                      return SellerRequestNotActive(
                          snapshot: docs, userId: userId);
                    }
                  default:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                }
              },
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

class SellerArchivedRequests extends StatefulWidget {
  const SellerArchivedRequests({Key? key}) : super(key: key);

  @override
  State<SellerArchivedRequests> createState() => _SellerArchivedRequestsState();
}

class _SellerArchivedRequestsState extends State<SellerArchivedRequests> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CloudService().getSellerRequestsArchived(userId: userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.active:
            if (!snapshot.data!.docs.isNotEmpty) {
              return const SellerRequestsArchivedIsEmpty();
            } else {
              final docs = snapshot.data!.docs;
              return SellerRequestsArchived(snapshot: docs);
            }

          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
