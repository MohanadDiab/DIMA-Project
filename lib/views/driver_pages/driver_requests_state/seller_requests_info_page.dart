import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/dimensions.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/utilities/dialogs/logout_dialog.dart';
import 'package:testapp/views/maps/requests_map.dart';

class SellerRequestsInfoPage extends StatefulWidget {
  final String name;
  final String picture;
  final String city;
  final number;
  final sellerUserId;
  const SellerRequestsInfoPage({
    Key? key,
    required this.name,
    required this.picture,
    required this.city,
    required this.number,
    required this.sellerUserId,
  }) : super(key: key);

  @override
  State<SellerRequestsInfoPage> createState() => _SellerRequestsInfoPageState();
}

class _SellerRequestsInfoPageState extends State<SellerRequestsInfoPage> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        genericText(
                            text: 'Requests locations visualized',
                            color: color5),
                        genericText4(
                          text:
                              'You might need to adjust the zoom level to see everything',
                          color: color5,
                          stringWeight: FontWeight.w200,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: getWidth(context: context),
                  height: 250,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: RequestsMap(
                      userId: userId, name: widget.name, address: widget.city),
                ),
              ),
              SizedBox(
                  child: StreamBuilder(
                stream: CloudService().getSellerRequests(userId: userId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                      final docs = snapshot.data!.docs;
                      final numOfOrders = docs.length;
                      final compensation = (docs.length * 4).toString();
                      final numOfOrdersString = docs.length.toString();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Container(
                              color: Colors.grey[100],
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      genericText(
                                          text: 'Orders and their details:',
                                          color: color5),
                                      genericText4(
                                          text:
                                              'Total number of orders: $numOfOrdersString',
                                          color: color5,
                                          stringWeight: FontWeight.w300),
                                      genericText4(
                                          text:
                                              'Your total revenue will sum up to: $compensation euros',
                                          color: color5,
                                          stringWeight: FontWeight.w300),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: SizedBox(
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 15,
                                  );
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  final price = docs[index].data()['price'];
                                  final name = docs[index].data()['name'];
                                  final item = docs[index].data()['item'];
                                  final notes = docs[index].data()['notes'];
                                  final pic = docs[index].data()['picture_url'];
                                  final numberC = docs[index].data()['number'];
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: genericButton(
                              primaryColor: color3,
                              pressColor: color2,
                              text: "Handle delivery",
                              onPressed: () async {
                                final shouldConfirm =
                                    await showConfirmRequestsDialog(context);
                                if (shouldConfirm) {
                                  CloudService().assignToDriver(
                                      driverUserId: userId,
                                      sellerUserId: widget.sellerUserId);
                                  Navigator.of(context).pop();
                                }
                              },
                              textColor: color2,
                              context: context,
                            ),
                          ),
                        ],
                      );

                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
