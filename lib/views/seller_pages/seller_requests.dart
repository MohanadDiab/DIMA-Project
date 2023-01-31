import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/views/seller_pages/seller_msg_info.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/seller_requests_info.dart';
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

class _SellerRequestsState extends State<SellerRequests>
    with AutomaticKeepAliveClientMixin {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
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
                      genericText(
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
                      genericText(
                        text: 'Archive',
                        color: color5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            title: bigText(
              text: 'My Requests',
              color: color5,
            ),
            actions: <Widget>[
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.notifications_active_outlined),
                    color: color5,
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              )
            ],
          ),
          drawer: const SellerRequestsInfoDrawer(),
          endDrawer: SellerMessagesInfoDrawer(userId: userId),
          body: const TabBarView(
            children: [
              SellerActiveRequests(),
              SellerArchivedRequests(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
    return StreamBuilder(
      stream: CloudService().getSellerAsSnapshot(userId: userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.active):
            final docs = snapshot.data.data();
            isAssigned = docs['is_assigned'] ?? false;
            isPublished = docs['is_published'] ?? false;
            driver = docs['assigned_driver'] ?? '';
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
                    List assignedRequests = [];
                    List notAssignedRequests = [];
                    final docs = snapshot.data!.docs;
                    for (var request in docs) {
                      if ((request.data()! as Map)['is_assigned']) {
                        assignedRequests.add(request);
                      } else {
                        notAssignedRequests.add(request);
                      }
                    }
                    if (docs.isEmpty) {
                      return const SellerRequestsIsEmpty();
                    } else if (assignedRequests.isNotEmpty) {
                      return SellerRequestsAssigned(
                          snapshot: assignedRequests, driver: driver);
                    } else if (notAssignedRequests.isNotEmpty && isPublished) {
                      return SellerRequestsActive(
                          snapshot: notAssignedRequests);
                    } else {
                      return SellerRequestNotActive(
                          snapshot: notAssignedRequests, userId: userId);
                    }
                  default:
                    return requestsPageShimmer(context: context);
                }
              },
            );
          default:
            return Container();
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
