import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/request_edit.dart';

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
            onPressed: () {
              Navigator.of(context).pushNamed(requests);
            },
            icon: const Icon(Icons.info_outline_rounded),
            color: color5,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(requests);
              },
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CloudService().getSellerRequests(userId: userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.done:
              final isActive = snapshot.data[1].data()['is_active'] ?? false;
              if (snapshot.data.isEmpty) {
                return const SellerRequestsIsEmpty();
              } else if (isActive) {
                return SellerRequestsActive(snapshot: snapshot);
              } else {
                return SellerRequestNotActive(snapshot: snapshot);
              }

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        });
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
    return FutureBuilder(
        future: CloudService().getSellerRequests(userId: userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.done:
              if (snapshot.data.isEmpty) {
                return const SellerRequestsIsEmpty();
              } else {
                return SellerRequestsArchived(snapshot: snapshot);
              }

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}

class SellerRequestsIsEmpty extends StatelessWidget {
  const SellerRequestsIsEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          GenericText(
              text: 'There are no requests at the moment!', color: color5),
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
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class SellerRequestsActive extends StatelessWidget {
  const SellerRequestsActive({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final dynamic snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle_notifications_outlined,
                    color: color3,
                  ),
                  const SizedBox(width: 5),
                  GenericText(
                    text: "Status: in Delivery",
                    color: color5,
                  ),
                ],
              ),
            ),
            GenericText2(
              text:
                  'Note: The delivery is in progress, you will be notified for each order deliverd',
              color: color5,
            ),
            SizedBox(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final isDelivered =
                      snapshot.data[index].data()['is_delivered'];
                  final price = snapshot.data[index].data()['price'];
                  final name = snapshot.data[index].data()['name'];
                  final item = snapshot.data[index].data()['item'];
                  final notes = snapshot.data[index].data()['notes'];
                  final pic = snapshot.data[index].data()['picture_url'];
                  final numberC = snapshot.data[index].data()['number'];
                  final String address =
                      snapshot.data[index].data()['address'].split(',')[0];

                  if (!isDelivered) {
                    return Container(
                      color: Colors.grey[100],
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            GenericRequestRow(
                              title: 'Name',
                              name: name,
                              icon: const Icon(Icons.person_outline),
                            ),
                            GenericRequestRow(
                              title: 'Address',
                              name: address,
                              icon: const Icon(Icons.location_history_outlined),
                            ),
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericRequestRow(
                                title: 'Number',
                                name: numberC.toString(),
                                icon: const Icon(
                                  Icons.call_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Item',
                                name: item,
                                icon: const Icon(
                                  Icons.store_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Price',
                                name: price.toString(),
                                icon: const Icon(Icons.attach_money_outlined),
                              ),
                              GenericRequestRow(
                                title: 'Notes',
                                name: notes,
                                icon: const Icon(Icons.textsms_outlined),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.image_outlined),
                                  GenericText4(
                                    text: 'Item image: ',
                                    color: color5,
                                    stringWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(pic),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: color4,
                                      width: 5,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(pic),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerRequestsArchived extends StatelessWidget {
  const SellerRequestsArchived({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final dynamic snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.circle_notifications_outlined,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 5),
                  GenericText(
                    text: "Status: Delivered",
                    color: color5,
                  ),
                ],
              ),
            ),
            GenericText2(
              text: 'Note: The deliveries shown here are already finished',
              color: color5,
            ),
            SizedBox(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final isDelivered =
                      snapshot.data[index].data()['is_delivered'];
                  final price = snapshot.data[index].data()['price'];
                  final name = snapshot.data[index].data()['name'];
                  final item = snapshot.data[index].data()['item'];
                  final notes = snapshot.data[index].data()['notes'];
                  final pic = snapshot.data[index].data()['picture_url'];
                  final numberC = snapshot.data[index].data()['number'];
                  final String address =
                      snapshot.data[index].data()['address'].split(',')[0];

                  if (!isDelivered) {
                    return const SizedBox();
                  } else {
                    return Container(
                      color: Colors.grey[100],
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            GenericRequestRow(
                              title: 'Name',
                              name: name,
                              icon: const Icon(Icons.person_outline),
                            ),
                            GenericRequestRow(
                              title: 'Address',
                              name: address,
                              icon: const Icon(Icons.location_history_outlined),
                            ),
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericRequestRow(
                                title: 'Number',
                                name: numberC.toString(),
                                icon: const Icon(
                                  Icons.call_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Item',
                                name: item,
                                icon: const Icon(
                                  Icons.store_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Price',
                                name: price.toString(),
                                icon: const Icon(Icons.attach_money_outlined),
                              ),
                              GenericRequestRow(
                                title: 'Notes',
                                name: notes,
                                icon: const Icon(Icons.textsms_outlined),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.image_outlined),
                                  GenericText4(
                                    text: 'Item image: ',
                                    color: color5,
                                    stringWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(pic),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: color4,
                                      width: 5,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(pic),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerRequestNotActive extends StatelessWidget {
  const SellerRequestNotActive({
    Key? key,
    this.snapshot,
  }) : super(key: key);

  final dynamic snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle_notifications_outlined,
                    color: color3,
                  ),
                  const SizedBox(width: 5),
                  GenericText(
                    text: "Status: Waiting for Driver",
                    color: color5,
                  ),
                ],
              ),
            ),
            GenericText2(
              text:
                  'Note: once a Driver accepts the requests, you can no longer edit the orders',
              color: color5,
            ),
            SizedBox(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final isDelivered =
                      snapshot.data[index].data()['is_delivered'];
                  final price = snapshot.data[index].data()['price'];
                  final name = snapshot.data[index].data()['name'];
                  final item = snapshot.data[index].data()['item'];
                  final notes = snapshot.data[index].data()['notes'];
                  final pic = snapshot.data[index].data()['picture_url'];
                  final numberC = snapshot.data[index].data()['number'];
                  final String address =
                      snapshot.data[index].data()['address'].split(',')[0];

                  if (!isDelivered) {
                    return const SizedBox();
                  } else {
                    return Container(
                      color: Colors.grey[100],
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            GenericRequestRow(
                              title: 'Name',
                              name: name,
                              icon: const Icon(Icons.person_outline),
                            ),
                            GenericRequestRow(
                              title: 'Address',
                              name: address,
                              icon: const Icon(Icons.location_history_outlined),
                            ),
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericRequestRow(
                                title: 'Number',
                                name: numberC.toString(),
                                icon: const Icon(
                                  Icons.call_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Item',
                                name: item,
                                icon: const Icon(
                                  Icons.store_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Price',
                                name: price.toString(),
                                icon: const Icon(Icons.attach_money_outlined),
                              ),
                              GenericRequestRow(
                                title: 'Notes',
                                name: notes,
                                icon: const Icon(Icons.textsms_outlined),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.image_outlined),
                                  GenericText4(
                                    text: 'Item image: ',
                                    color: color5,
                                    stringWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(pic),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: color4,
                                      width: 5,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(pic),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
