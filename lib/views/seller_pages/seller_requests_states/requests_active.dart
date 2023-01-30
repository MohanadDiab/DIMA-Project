import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';

class SellerRequestsActive extends StatelessWidget {
  const SellerRequestsActive({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final dynamic snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigText(text: 'Welcome back', color: color5),
                    genericText4(
                      text: "Searching for a driver...",
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(),
          ),
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
          orders(context: context, snapshot: snapshot),
        ],
      ),
    );
  }
}
