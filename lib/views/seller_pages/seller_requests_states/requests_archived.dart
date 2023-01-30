import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';

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
                  genericText(
                    text: "Status: Delivered",
                    color: color5,
                  ),
                ],
              ),
            ),
            genericText2(
              text: 'Note: The deliveries shown here are already finished',
              color: color5,
            ),
            orders(context: context, snapshot: snapshot),
          ],
        ),
      ),
    );
  }
}
