import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/dimensions.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
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
        child: FutureBuilder(
      future: CloudService().getDriverInfo(userId: driver),
      builder: (BuildContext context, AsyncSnapshot _snapshot) {
        switch (_snapshot.connectionState) {
          case (ConnectionState.waiting):
            return const Center(
              child: CircularProgressIndicator(),
            );
          case (ConnectionState.done):
            final driverInfo = _snapshot.data;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      genericText(
                          text: 'Hi, I will be delivering your orders! ',
                          color: color5),
                      const SizedBox(height: 15),
                      driverCard(
                        driverInfo: driverInfo,
                        context: context,
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
                    orders(context: context, snapshot: snapshot),
                  ],
                ),
              ],
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    ));
  }

  Widget driverCard({required driverInfo, required BuildContext context}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
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
              call(number: driverInfo['number'].toString());
            },
            child: Row(
              children: [
                circularAvatarImageSmall(
                  networkImage: driverInfo['picture_url'],
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
                          text: driverInfo['name'],
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
                          text: driverInfo['city'],
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
              call(number: driverInfo['number'].toString());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circularAvatarImageSmall(
                  networkImage: driverInfo['picture_url'],
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
                          text: driverInfo['name'],
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
                          text: driverInfo['city'],
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
        }
      },
    );
  }
}
