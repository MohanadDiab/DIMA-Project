import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/views/driver_pages/driver_camera.dart';
import 'package:testapp/views/driver_pages/driver_msg_info.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/driver_pages/driver_requests_state/driver_requests_inactive.dart';
import 'package:testapp/views/driver_pages/driver_requests_state/driver_requests_active.dart';
import 'package:testapp/views/seller_pages/seller_requests_info.dart';
import 'package:testapp/views/seller_pages/seller_msg_info.dart';
import 'package:testapp/views/seller_pages/seller_requests_states/requests_archived.dart';
import 'package:testapp/views/seller_pages/seller_requests_states/requests_empty.dart';

class DriverRequests extends StatefulWidget {
  const DriverRequests({Key? key}) : super(key: key);

  @override
  State<DriverRequests> createState() => _DriverRequestsState();
}

class _DriverRequestsState extends State<DriverRequests>
    with AutomaticKeepAliveClientMixin {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: size.height,
          width: size.height,
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
            endDrawer: DriverMessagesInfoDrawer(userId: userId),
            body: const TabBarView(
              children: [
                DriverRequestsView(),
                DriverArchivedRequests(),
              ],
            ),
          ), // Your Widget
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

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
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: CloudService().getAliveDriverRequests(userId: userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return requestsPageShimmer(context: context);
              case ConnectionState.active:
                if (!snapshot.data!.docs.isEmpty) {
                  final docs = snapshot.data!.docs;
                  return DriverRequestsActive(snapshot: docs);
                } else {
                  return const DriverRequestsList();
                }
              default:
                return requestsPageShimmer(context: context);
            }
          },
        ),
      ),
    );
  }
}

class DriverArchivedRequests extends StatefulWidget {
  const DriverArchivedRequests({Key? key}) : super(key: key);

  @override
  State<DriverArchivedRequests> createState() => _DriverArchivedRequestsState();
}

class _DriverArchivedRequestsState extends State<DriverArchivedRequests> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CloudService().getDriverRequestsArchived(userId: userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: Center(child: CircularProgressIndicator()),
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
              child: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
