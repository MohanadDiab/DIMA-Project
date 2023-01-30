import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

class DriverRequestsActive extends StatelessWidget {
  DriverRequestsActive({Key? key, this.snapshot}) : super(key: key);

  final dynamic snapshot;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bigText(text: 'Welcome back', color: color5),
                      genericText4(
                        text: "You are currently delivering to:",
                        color: color5,
                        stringWeight: FontWeight.w300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/emoji/waving_hand.png',
                  height: 35,
                ),
              ],
            ),
            FutureBuilder(
              future: CloudService().getDriverSellerInfo(userId: userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());

                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      print(snapshot);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.grey[100],
                          onPrimary: color3,
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          call(number: snapshot.data['number'].toString());
                        },
                        child: Row(
                          children: [
                            circularAvatarImageSmall(
                              networkImage: snapshot.data['picture_url'],
                              placeholderIcon: Icons.person,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.person_outline),
                                    const SizedBox(width: 5),
                                    genericText2(
                                      text: snapshot.data['name'],
                                      color: color5,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    const SizedBox(width: 5),
                                    genericText2(
                                      text: snapshot.data['city'],
                                      color: color5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            Column(
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.call_outlined,
                                    color: color2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
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
                    final String address = snapshot[index].data()['address'];

                    return genericExpandableList(
                      context: context,
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
            ),
          ],
        ),
      ),
    );
  }
}
