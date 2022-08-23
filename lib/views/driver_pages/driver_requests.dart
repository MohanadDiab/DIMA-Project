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
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.done:
                              if (snapshot.data.isNotEmpty) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            height: 20,
                                          );
                                        },
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          final price = snapshot.data[index]
                                              .data()['price'];
                                          final name = snapshot.data[index]
                                              .data()['name'];
                                          final item = snapshot.data[index]
                                              .data()['item'];
                                          final notes = snapshot.data[index]
                                              .data()['notes'];
                                          final pic = snapshot.data[index]
                                              .data()['picture_url'];

                                          final numberC = snapshot.data[index]
                                              .data()['number'];

                                          final String address = snapshot
                                              .data[index]
                                              .data()['address']
                                              .split(',')[0];
                                          final bool isDelivered = snapshot
                                              .data[index]
                                              .data()['is_delivered'];

                                          final int number = index + 1;

                                          return Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GenericText4(
                                                    text: 'order#$number',
                                                    color: color5,
                                                    stringWeight:
                                                        FontWeight.w600),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.person),
                                                        GenericText4(
                                                          text: 'Name: ',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        GenericText4(
                                                          text: name,
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.call),
                                                        GenericText4(
                                                          text: 'Number: ',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        GenericText4(
                                                          text: numberC
                                                              .toString(),
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.store),
                                                        GenericText4(
                                                          text: 'Item: ',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        GenericText4(
                                                          text: item,
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.money),
                                                        GenericText4(
                                                          text: 'price: ',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        GenericText4(
                                                          text:
                                                              price.toString(),
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        const Icon(
                                                            Icons.attach_money),
                                                        GenericText4(
                                                          text: '+ 3',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        const Icon(
                                                            Icons.attach_money),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons
                                                            .location_history_outlined),
                                                        GenericText4(
                                                          text: 'Address: ',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        GenericText4(
                                                          text: address,
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.textsms),
                                                        GenericText4(
                                                          text: 'Notes: ',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        GenericText4(
                                                          text: notes,
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.image),
                                                        GenericText4(
                                                          text: 'Item image: ',
                                                          color: color5,
                                                          stringWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
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
                                                                    image:
                                                                        NetworkImage(
                                                                            pic),
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 120,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: color4,
                                                            width: 5,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                pic),
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: !isDelivered,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(25),
                                                        child: GenericButton(
                                                          primaryColor:
                                                              Colors.green,
                                                          pressColor: color2,
                                                          text: 'Call',
                                                          onPressed: () {
                                                            call(
                                                                number: numberC
                                                                    .toString());
                                                          },
                                                          textColor: color2,
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: !isDelivered,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 25,
                                                          right: 25,
                                                          bottom: 25,
                                                        ),
                                                        child: GenericButton(
                                                          primaryColor: color3,
                                                          pressColor: color2,
                                                          text:
                                                              'Set as completed',
                                                          onPressed: () async {
                                                            CloudService()
                                                                .itemDelivered(
                                                                    userId:
                                                                        userId,
                                                                    customer:
                                                                        name);
                                                            setState(() {});
                                                          },
                                                          textColor: color2,
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isDelivered,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(25),
                                                        child: GenericButton(
                                                          primaryColor:
                                                              Colors.green,
                                                          pressColor: color2,
                                                          text: 'Delivered',
                                                          onPressed: () {},
                                                          textColor: color2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const SellerRequestsList();
                              }
                            default:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
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
                              CircleAvatar(
                                radius: 75,
                                backgroundImage: NetworkImage(
                                    snapshot.data[index].data()['picture_url']),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GenericText(
                                    text: snapshot.data[index].data()['name'],
                                    color: color4,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  IconButton(
                                    onPressed: () {
                                      call(
                                        number: snapshot.data[index]
                                            .data()['number']
                                            .toString(),
                                      );
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
