import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';

class DriverRequestsInactive extends StatelessWidget {
  DriverRequestsInactive({Key? key, this.snapshot}) : super(key: key);

  final dynamic snapshot;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

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
                    text: "Status: Assigning a driver",
                    color: color5,
                  ),
                ],
              ),
            ),
            GenericText2(
              text:
                  'Note: your order is published, you will be notified once a driver is assigned',
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
                  final price = snapshot[index].data()['price'];
                  final name = snapshot[index].data()['name'];
                  final item = snapshot[index].data()['item'];
                  final notes = snapshot[index].data()['notes'];
                  final pic = snapshot[index].data()['picture_url'];
                  final numberC = snapshot[index].data()['number'];
                  final String address =
                      snapshot[index].data()['address'].split(',')[0];

                  return GenericExpandableList(
                    name: name,
                    address: address,
                    numberC: numberC,
                    item: item,
                    price: price,
                    notes: notes,
                    pic: pic,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}