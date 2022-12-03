import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';

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
                  genericText(
                    text: "Status: Assigning a driver",
                    color: color5,
                  ),
                ],
              ),
            ),
            genericText2(
              text:
                  'Note: your order is published, you will be notified once a driver is assigned',
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
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
