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
          SliverToBoxAdapter(
            child: SizedBox(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
                  child: GenericText2(
                      text:
                          'After confirming the requests you will have to navigate to the seller to fetch the orders',
                      color: color5),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future:
                            CloudService().getDriverRequests(userId: userId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator());
                            case ConnectionState.done:
                              if (snapshot.data.isNotEmpty) {
                                return ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      height: 10,
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: color2,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.person),
                                              GenericText(
                                                text: snapshot.data[index]
                                                    .data()['name'],
                                                color: color4,
                                              ),
                                              const Expanded(child: SizedBox()),
                                              IconButton(
                                                onPressed: () {
                                                  call(
                                                      number: snapshot
                                                          .data[index]
                                                          .data()['number']
                                                          .toString());
                                                },
                                                icon: const Icon(Icons.call),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 2.5,
                                            color: color4,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.store),
                                              GenericText(
                                                text: snapshot.data[index]
                                                    .data()['item'],
                                                color: color4,
                                              ),
                                              const Expanded(child: SizedBox()),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Container(
                                                          height: 120,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: NetworkImage(snapshot
                                                                      .data[index]
                                                                      .data()[
                                                                  'picture_url']),
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const Icon(Icons
                                                    .photo_size_select_actual_rounded),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: GenericButton(
                                                primaryColor: color4,
                                                pressColor: color2,
                                                text: 'See location',
                                                onPressed: () {},
                                                textColor: color2),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const SellerRequestsList();
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

class SellerRequestsList extends StatefulWidget {
  const SellerRequestsList({Key? key}) : super(key: key);

  @override
  State<SellerRequestsList> createState() => _SellerRequestsListState();
}

class _SellerRequestsListState extends State<SellerRequestsList> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GenericText(
          text: 'Check available requests',
          color: color5,
        ),
        const SizedBox(height: 10),
        Container(
          height: 2,
          color: color1,
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: CloudService().getAllRequests(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: color2,
                            border: Border.all(color: color4),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GenericText(
                                    text: snapshot.data[index].data()['name'],
                                    color: color4,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.call),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              Container(
                                height: 2.5,
                                color: color4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GenericText(
                                    text: '5 Customers',
                                    color: color4,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GenericText(
                                    text: 'Milan',
                                    color: color4,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: GenericButton(
                                    primaryColor: color4,
                                    pressColor: color2,
                                    text: 'Take request',
                                    onPressed: () async {
                                      CloudService().assignToDriver(
                                        userId: userId,
                                        sellerName:
                                            snapshot.data[index].data()['name'],
                                      );
                                      setState(() {});
                                    },
                                    textColor: color2),
                              ),
                            ],
                          ),
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
    );
  }
}
