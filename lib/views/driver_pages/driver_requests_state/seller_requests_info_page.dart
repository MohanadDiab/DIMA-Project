import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/seller_requests_states/requests_active.dart';

class SellerRequestsInfoPage extends StatefulWidget {
  final String name;
  final String picture;
  final String city;
  final number;
  const SellerRequestsInfoPage({
    Key? key,
    required this.name,
    required this.picture,
    required this.city,
    required this.number,
  }) : super(key: key);

  @override
  State<SellerRequestsInfoPage> createState() => _SellerRequestsInfoPageState();
}

class _SellerRequestsInfoPageState extends State<SellerRequestsInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              shape: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: color5,
              elevation: 0,
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: bigText(text: "Seller Requests", color: color5),
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'sellerIcon',
                      child: circularAvatarImage(
                        networkImage: widget.picture,
                        placeholderIcon: Icons.person,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        genericText(text: widget.name, color: color5),
                        const SizedBox(width: 10),
                        Container(height: 20, width: 1, color: color5),
                        const SizedBox(width: 5),
                        Icon(Icons.location_pin, color: color5),
                        const SizedBox(width: 2.5),
                        genericText(text: widget.city, color: color5),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SizedBox(
          child: FutureBuilder(
            future: CloudService().getSellerIDFromName(name: widget.name),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  return const Center(
                    child: Center(child: CircularProgressIndicator()),
                  );
                case (ConnectionState.done):
                  final sellerId = snapshot.data;
                  return StreamBuilder(
                    stream: CloudService().getSellerRequests(userId: sellerId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.active:
                          return StreamBuilder(
                            stream: CloudService()
                                .getSellerRequests(userId: sellerId),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                case ConnectionState.active:
                                  final docs = snapshot.data!.docs;
                                  return Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: SizedBox(
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 15,
                                          );
                                        },
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: docs.length,
                                        itemBuilder: (context, index) {
                                          final price =
                                              docs[index].data()['price'];
                                          final name =
                                              docs[index].data()['name'];
                                          final item =
                                              docs[index].data()['item'];
                                          final notes =
                                              docs[index].data()['notes'];
                                          final pic =
                                              docs[index].data()['picture_url'];
                                          final numberC =
                                              docs[index].data()['number'];
                                          final String address = docs[index]
                                              .data()['address']
                                              .split(',')[0];

                                          return genericExpandableList(
                                            name: name,
                                            address: address,
                                            numberC: numberC,
                                            item: item,
                                            price: price,
                                            notes: notes,
                                            pic: pic,
                                            context: context,
                                          );
                                        },
                                      ),
                                    ),
                                  );

                                default:
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                              }
                            },
                          );
                        default:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    },
                  );

                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
