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
                driverButton(driverSnapshot: driver, context: context),
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
      ),
    );
  }
}
