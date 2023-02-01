import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/utilities/dialogs/logout_dialog.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

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
          child: Column(
            children: [
              const SizedBox(height: 15),
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
                      text: "Status: Waiting for a driver",
                      color: color5,
                    ),
                  ],
                ),
              ),
              genericText2(
                text:
                    'Note: once you publish the orders, you can no longer edit them',
                color: color5,
              ),
              orders2(context: context, snapshot: snapshot, userId: userId),
              const SizedBox(height: 100),
            ],
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
                  genericButton3(
                    context: context,
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
                  const SizedBox(width: 15),
                  genericButton3(
                    context: context,
                    color: color3,
                    text: "Publish",
                    icon: Icon(
                      Icons.publish_outlined,
                      color: color2,
                    ),
                    onPressed: () async {
                      final shouldConfirm =
                          await showConfirmPublishDialog(context);
                      if (shouldConfirm) {
                        CloudService().publishSeller(userId: userId);
                      }
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
