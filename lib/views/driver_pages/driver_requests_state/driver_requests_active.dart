import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        genericText(
          text: 'Check available requests',
          color: color5,
        ),
        const SizedBox(height: 10),
        Container(
          height: 2,
          color: color1,
        ),
        const SizedBox(height: 10),
        FutureBuilder(
          future: CloudService().getAllRequests(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData && true) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 10,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: color2,
                            border: Border.all(color: color4),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundImage: NetworkImage(
                                    snapshot.data[index].data()['picture_url']),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  genericText(
                                    text: snapshot.data[index].data()['name'],
                                    color: color4,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  IconButton(
                                    onPressed: () {
                                      call(
                                        number: snapshot.data[index]
                                            .data()['number']
                                            .toString(),
                                      );
                                    },
                                    icon: const Icon(Icons.call),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              Container(
                                height: 2.5,
                                color: color4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  genericText(
                                    text: '5 Customers',
                                    color: color4,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  genericText(
                                    text: 'Milan',
                                    color: color4,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: genericButton(
                                    context: context,
                                    primaryColor: color4,
                                    pressColor: color2,
                                    text: 'Take request',
                                    onPressed: () async {
                                      CloudService().assignToDriver(
                                        userId: userId,
                                        sellerName:
                                            snapshot.data[index].data()['name'],
                                      );
                                      setState(() {});
                                    },
                                    textColor: color2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
