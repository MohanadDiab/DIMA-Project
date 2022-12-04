import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/request_edit.dart';

class SellerRequestNotActive extends StatelessWidget {
  const SellerRequestNotActive({
    Key? key,
    required this.snapshot,
    required this.userId,
  }) : super(key: key);

  final dynamic userId;
  final dynamic snapshot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
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
                    genericText(
                      text: "Status: Waiting for a driver",
                      color: color5,
                    ),
                  ],
                ),
              ),
              genericText2(
                text:
                    'Note: once you publish the orders, you can no longer edit them',
                color: color5,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.length,
                    itemBuilder: (context, index) {
                      final price = snapshot[index].data()['price'];
                      final name = snapshot[index].data()['name'];
                      final item = snapshot[index].data()['item'];
                      final notes = snapshot[index].data()['notes'];
                      final pic = snapshot[index].data()['picture_url'];
                      final numberC = snapshot[index].data()['number'];
                      final String address =
                          snapshot[index].data()['address'].split(',')[0];

                      return Column(children: [
                        genericExpandableList2(
                          userId: userId,
                          name: name,
                          address: address,
                          numberC: numberC,
                          item: item,
                          price: price,
                          notes: notes,
                          pic: pic,
                          context: context,
                        ),
                      ]);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  genericButton3(
                    color: Colors.green,
                    text: "Add order",
                    icon: Icon(
                      Icons.add,
                      color: color2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(requests);
                    },
                  ),
                  genericButton3(
                    color: color3,
                    text: "Publish orders",
                    icon: Icon(
                      Icons.publish_outlined,
                      color: color2,
                    ),
                    onPressed: () async {
                      CloudService().publishSeller(userId: userId);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
