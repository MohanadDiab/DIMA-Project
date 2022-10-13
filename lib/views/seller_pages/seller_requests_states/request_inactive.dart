import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/request_edit.dart';

class SellerRequestNotActive extends StatelessWidget {
  const SellerRequestNotActive({
    Key? key,
    required this.snapshot,
    required this.userId,
  }) : super(key: key);

  final dynamic userId;
  final dynamic snapshot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
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
                        text: "Status: Waiting to be published",
                        color: color5,
                      ),
                    ],
                  ),
                ),
                GenericText2(
                  text:
                      'Note: once you publish the orders, you can no longer edit them',
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
                      final isDelivered =
                          snapshot[index].data()['is_delivered'];
                      final price = snapshot[index].data()['price'];
                      final name = snapshot[index].data()['name'];
                      final item = snapshot[index].data()['item'];
                      final notes = snapshot[index].data()['notes'];
                      final pic = snapshot[index].data()['picture_url'];
                      final numberC = snapshot[index].data()['number'];
                      final String address =
                          snapshot[index].data()['address'].split(',')[0];

                      if (isDelivered) {
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
                                  icon: const Icon(
                                      Icons.location_history_outlined),
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
                                    icon:
                                        const Icon(Icons.attach_money_outlined),
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
                                    child: Center(
                                      child: CircularAvatarImage(
                                        networkImage: pic,
                                        placeholderIcon:
                                            Icons.catching_pokemon_outlined,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              onPrimary: color3,
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditRequests(cname: name),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Row(
                                                children: [
                                                  const Expanded(
                                                      child: SizedBox()),
                                                  Icon(
                                                    Icons.edit_outlined,
                                                    color: color3,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  GenericText4(
                                                    text: 'Edit',
                                                    color: color5,
                                                    stringWeight:
                                                        FontWeight.w300,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Expanded(
                                                      child: SizedBox()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              onPrimary: color3,
                                              primary: Colors.white,
                                              fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .8,
                                                  60),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Long press to delete entry'),
                                                ),
                                              );
                                            },
                                            onLongPress: () async {
                                              await CloudService()
                                                  .deleteSellerRequest(
                                                      userId: userId,
                                                      name: name);
                                            },
                                            child: Row(
                                              children: [
                                                const Expanded(
                                                    child: SizedBox()),
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: color3,
                                                ),
                                                const SizedBox(width: 10),
                                                GenericText4(
                                                  text: 'Delete',
                                                  color: color5,
                                                  stringWeight: FontWeight.w300,
                                                ),
                                                const SizedBox(width: 10),
                                                const Expanded(
                                                    child: SizedBox()),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenericButton3(
                    color: Colors.green,
                    text: "Add order",
                    icon: Icon(
                      Icons.add,
                      color: color2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(requests);
                    },
                  ),
                  GenericButton3(
                    color: color3,
                    text: "Publish orders",
                    icon: Icon(
                      Icons.publish_outlined,
                      color: color2,
                    ),
                    onPressed: () async {
                      CloudService().publishSeller(userId: userId);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
