import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/dimensions.dart';
import 'package:testapp/constants/url.dart';
import 'package:testapp/extensions/chat_card.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:empty_widget/empty_widget.dart';

class SellerMessagesInfoDrawer extends StatelessWidget {
  final String userId;
  const SellerMessagesInfoDrawer({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: getWidth(context: context) * 0.9,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: StreamBuilder(
          stream: CloudService().getSellerReceivedMsg(userId: userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (snapshot.data != null) {
                  final docs = snapshot.data.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) => ChatCard(
                      chat: docs[index].data(),
                      press: () {},
                    ),
                  );
                } else {
                  return EmptyWidget(
                    image: null,
                    packageImage: PackageImage.Image_1,
                    title: 'No message',
                    subTitle: 'No message available yet',
                    titleTextStyle: TextStyle(
                      fontSize: 22,
                      color: Color(0xff9da9c7),
                      fontWeight: FontWeight.w500,
                    ),
                    subtitleTextStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xffabb8d6),
                    ),
                  );
                }
              default:
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
