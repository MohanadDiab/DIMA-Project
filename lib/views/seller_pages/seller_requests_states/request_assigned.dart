import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';

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
                genericText(
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    call(number: driver['number'].toString());
                  },
                  child: Row(
                    children: [
                      circularAvatarImageSmall(
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
                              genericText2(
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
                              genericText2(
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
          Column(
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
                      text: "Status: Driver assigned",
                      color: color5,
                    ),
                  ],
                ),
              ),
              genericText2(
                text:
                    'Note: your driver is assigned, you will be notified for each delivery',
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
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
