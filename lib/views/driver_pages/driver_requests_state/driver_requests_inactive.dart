import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/url.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

class DriverRequestsList extends StatefulWidget {
  const DriverRequestsList({Key? key}) : super(key: key);

  @override
  State<DriverRequestsList> createState() => _DriverRequestsListState();
}

class _DriverRequestsListState extends State<DriverRequestsList> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CloudService().getAllActiveRequests(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            final docs = snapshot.data!.docs;
            if (snapshot.hasData) {
              return SingleChildScrollView(
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
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final name = docs[index].data()['name'];
                            var pic = docs[index].data()['picture_url'];
                            pic ??= profilePlaceholderImage;
                            final number = docs[index].data()['number'];
                            final String city =
                                docs[index].data()['city'].split(',')[0];
                            return sellerCard(name: name, context: context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
