import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/views/seller_pages/seller_requests_states/requests_active.dart';

class SellerRequestsAssigned extends StatelessWidget {
  const SellerRequestsAssigned({
    Key? key,
    required this.snapshot,
    required this.driver,
  }) : super(key: key);

  final dynamic snapshot;
  final dynamic driver;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GenericText(
                    text: 'Hi, I will be delivering your orders! ',
                    color: color5),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.grey[100],
                    onPrimary: color3,
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    call(number: driver['number'].toString());
                  },
                  child: Row(
                    children: [
                      CircularAvatarImageSmall(
                        networkImage: driver['picture_url'],
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
                              GenericText2(
                                text: driver['name'],
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
                              GenericText2(
                                text: driver['city'],
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
                ),
              ],
            ),
          ),
          SellerRequestsActive(snapshot: snapshot),
        ],
      ),
    );
  }
}
