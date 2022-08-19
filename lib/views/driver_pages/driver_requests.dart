import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

class DriverRequestsView extends StatefulWidget {
  const DriverRequestsView({Key? key}) : super(key: key);

  @override
  State<DriverRequestsView> createState() => _DriverRequestsViewState();
}

class _DriverRequestsViewState extends State<DriverRequestsView> {
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: GenericText(
                text: 'Deliveries',
                color: color2,
              ),
              background: Container(
                color: color3,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: Center(
                child: Text('Scroll down to see next deliveries'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GenericText(
                        text: 'Check current requests',
                        color: color2,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: color1,
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future:
                            CloudService().getDriverRequests(userId: userId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                return ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      height: 10,
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Box1(
                                      name: snapshot.data[index].data()['name'],
                                      order:
                                          snapshot.data[index].data()['item'],
                                    );
                                  },
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            default:
                              return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // This is fot the future requests
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: color4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GenericText(
                        text: 'Check available requests',
                        color: color2,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: color1,
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: CloudService()
                            .getSellerRequests(userId: 'mockseller1'),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                return ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      height: 10,
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Expanded(
                                      child: Box(
                                        name:
                                            snapshot.data[index].data()['name'],
                                        numberOfOrders: snapshot.data.length,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            default:
                              return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
