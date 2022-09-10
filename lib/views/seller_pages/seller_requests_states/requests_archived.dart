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
                  GenericText(
                    text: "Status: Delivered",
                    color: color5,
                  ),
                ],
              ),
            ),
            GenericText2(
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
                    return Container(
                      color: Colors.grey[100],
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            GenericRequestRow(
                              title: 'Name',
                              name: name,
                              icon: const Icon(Icons.person_outline),
                            ),
                            GenericRequestRow(
                              title: 'Address',
                              name: address,
                              icon: const Icon(Icons.location_history_outlined),
                            ),
                          ],
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GenericRequestRow(
                                title: 'Number',
                                name: numberC.toString(),
                                icon: const Icon(
                                  Icons.call_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Item',
                                name: item,
                                icon: const Icon(
                                  Icons.store_outlined,
                                ),
                              ),
                              GenericRequestRow(
                                title: 'Price',
                                name: price.toString(),
                                icon: const Icon(Icons.attach_money_outlined),
                              ),
                              GenericRequestRow(
                                title: 'Notes',
                                name: notes,
                                icon: const Icon(Icons.textsms_outlined),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.image_outlined),
                                  GenericText4(
                                    text: 'Item image: ',
                                    color: color5,
                                    stringWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                          height: 120,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(pic),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: color4,
                                      width: 5,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(pic),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
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
