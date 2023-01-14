import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/customPageRouter.dart';
import 'package:testapp/constants/url.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/driver_pages/driver_requests_state/seller_requests_info_page.dart';

class DriverRequestsList extends StatefulWidget {
  const DriverRequestsList({Key? key}) : super(key: key);

  @override
  State<DriverRequestsList> createState() => _DriverRequestsListState();
}

class _DriverRequestsListState extends State<DriverRequestsList> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  int _selectedIndex = 0;
  String _city = "Milan";

  final List<String> options = ['Show all', 'My City'];

  final List<String> descriptions = [
    'Shows all requests posted',
    'Shows all requests in your city'
  ];

  final List optionsIcons = [
    Icons.wysiwyg_outlined,
    Icons.location_city_outlined,
  ];

  List _queries = [
    CloudService().getAllActiveRequests(),
    CloudService().getAllActiveRequests(),
  ];
  @override
  void initState() {
    getDriverData(userId: userId);
    super.initState();
  }

  void getDriverData({required String userId}) async {
    final driverInfo = await CloudService().getDriverProfile(userId: userId);
    _city = driverInfo!['city'];
    _queries = [
      CloudService().getAllActiveRequests(),
      CloudService().getClosestRequests(city: _city),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _queries[_selectedIndex],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            final docs = snapshot.data!.docs;
            if (snapshot.data!.docs.isNotEmpty) {
              return SingleChildScrollView(
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
                                text: "Sort requests based on:",
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
                    Container(
                      height: 150,
                      color: color5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: color3,
                                primary: index == _selectedIndex
                                    ? Colors.white
                                    : Colors.white60,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      optionsIcons[index],
                                      color: color5,
                                      size: 75,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        genericText4(
                                          text: options[index],
                                          color: color5,
                                          stringWeight: FontWeight.w500,
                                        ),
                                        genericText4(
                                          text: descriptions[index],
                                          color: color5,
                                          stringWeight: FontWeight.w300,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            genericText(
                              text: "Available requests",
                              color: color5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: genericText2(
                        text:
                            'Note: The shown requests are affected by the filter you choose above',
                        color: color5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 20,
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
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                primary: Colors.grey[200],
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
                                Navigator.of(context).push(
                                  MyRoute(
                                    builder: (BuildContext context) =>
                                        SellerRequestsInfoPage(
                                            number: number,
                                            name: name,
                                            picture: pic,
                                            city: city,
                                            userId: userId),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Hero(
                                    tag: 'sellerIcon$index',
                                    child: circularAvatarImageSmall(
                                      networkImage: pic,
                                      placeholderIcon: Icons.person,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          genericText4(
                                            text: name,
                                            color: color5,
                                            stringWeight: FontWeight.w300,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.location_on_outlined),
                                          const SizedBox(width: 5),
                                          genericText2(
                                            text: city,
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
                                          child: IconButton(
                                        onPressed: () {
                                          call(number: number.toString());
                                        },
                                        icon: Icon(
                                          Icons.call_outlined,
                                          color: color2,
                                        ),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
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
                                text: "Sort requests based on:",
                                color: color5,
                                stringWeight: FontWeight.w200,
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
                    Container(
                      height: 150,
                      color: color5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: color3,
                                primary: index == _selectedIndex
                                    ? Colors.white
                                    : Colors.white60,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 20, 5, 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      optionsIcons[index],
                                      color: color5,
                                      size: 75,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        genericText4(
                                          text: options[index],
                                          color: color5,
                                          stringWeight: FontWeight.w500,
                                        ),
                                        genericText4(
                                          text: descriptions[index],
                                          color: color5,
                                          stringWeight: FontWeight.w300,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            genericText(
                              text: "Available requests",
                              color: color5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            genericText4(
                                text:
                                    "Oops, seems your search didn't yield any results",
                                color: color5,
                                stringWeight: FontWeight.w300),
                            Icon(
                              Icons.search_off_outlined,
                              size: 200,
                              color: color5,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
