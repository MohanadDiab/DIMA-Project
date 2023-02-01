import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
                      return sellerCard(context: context, snapshot: snapshot);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const Divider(),
            orders(context: context, snapshot: snapshot),
          ],
        ),
      ),
    );
  }

  Widget sellerCard(
      {required AsyncSnapshot<dynamic> snapshot,
      required BuildContext context}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(400, 125),
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
                CircleAvatar(
                  child: Icon(
                    Icons.call_outlined,
                    color: color2,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          );
        } else {
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
        }
      },
    );
  }
}
