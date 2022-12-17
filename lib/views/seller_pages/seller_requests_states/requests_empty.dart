import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/widgets/custom_widgets.dart';

class SellerRequestsIsEmpty extends StatelessWidget {
  const SellerRequestsIsEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          genericText(
              text: 'There are no requests at the moment!', color: color5),
          SizedBox(
            height: 450,
            child: Lottie.asset('assets/no requests.json'),
          ),
          const SizedBox(height: 50),
          genericButton(
              context: context,
              primaryColor: color3,
              pressColor: color2,
              text: 'Add a request',
              onPressed: () {
                Navigator.of(context).pushNamed(requests);
              },
              textColor: color2),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class SellerRequestsArchivedIsEmpty extends StatelessWidget {
  const SellerRequestsArchivedIsEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          genericText(text: 'No deliveries have been made!', color: color5),
          SizedBox(
            height: 400,
            child: Lottie.asset('assets/no requests.json'),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: genericText4(
              text:
                  'Note: when a delivery is made by a deliveryman, it will appear here alongside its respective info',
              color: color3,
              stringWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
