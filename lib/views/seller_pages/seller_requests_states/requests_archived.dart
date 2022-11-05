import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';

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
                  genericText(
                    text: "Status: Delivered",
                    color: color5,
                  ),
                ],
              ),
            ),
            genericText2(
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
                itemCount: snapshot.length,
                itemBuilder: (context, index) {
                  final isDelivered = snapshot[index].data()['is_delivered'];
                  final price = snapshot[index].data()['price'];
                  final name = snapshot[index].data()['name'];
                  final item = snapshot[index].data()['item'];
                  final notes = snapshot[index].data()['notes'];
                  final pic = snapshot[index].data()['picture_url'];
                  final numberC = snapshot[index].data()['number'];
                  final String address =
                      snapshot[index].data()['address'].split(',')[0];

                  if (!isDelivered) {
                    return const SizedBox();
                  } else {
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
