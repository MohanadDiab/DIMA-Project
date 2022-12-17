import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/dimensions.dart';
import 'package:testapp/constants/url.dart';
import 'package:testapp/widgets/custom_widgets.dart';

class SellerRequestsInfoDrawer extends StatelessWidget {
  const SellerRequestsInfoDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: getWidth(context: context) * 0.9,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bigText(text: "Requests guide", color: color5),
              const Divider(),
              genericText(
                text: "You can view current requests at the tab:",
                color: color5,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_forward_outlined),
                  const SizedBox(width: 10),
                  Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task,
                            color: color3,
                          ),
                          const SizedBox(width: 5),
                          genericText(
                            text: 'Active',
                            color: color5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                color: color3,
                height: 1,
                width: 300,
              ),
              genericText(
                text: "You can view archived requests at the tab:",
                color: color5,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_forward_outlined),
                  const SizedBox(width: 10),
                  Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.archive,
                            color: color3,
                          ),
                          const SizedBox(width: 5),
                          genericText(
                            text: 'Archive',
                            color: color5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                color: color3,
                height: 1,
                width: 300,
              ),
              const SizedBox(height: 10),
              genericText(
                text:
                    "Once you start adding your orders, it will look something like this. You can publish the order using publish orders buttons.",
                color: color5,
              ),
              Container(
                height: 900,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/publishable orders.jpg'),
                      fit: BoxFit.contain),
                ),
              ),
              Container(
                color: color3,
                height: 1,
                width: 300,
              ),
              const SizedBox(height: 10),
              genericText(
                text:
                    "Once a driver is assigned, this field will appear. If you press anywhere inside, you will be redierected to call the driver.",
                color: color5,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.grey[200],
                  onPrimary: color3,
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    circularAvatarImageSmall(
                      networkImage: profilePlaceholderImage,
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
                              text: "Driver name",
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
                              text: "Driver location",
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
