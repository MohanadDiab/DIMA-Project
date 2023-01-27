import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/custom_page_router.dart';
import 'package:testapp/constants/dimensions.dart';
import 'package:testapp/constants/skeleton.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/request_edit.dart';
import 'package:url_launcher/url_launcher.dart';

Widget genericButton({
  required primaryColor,
  required pressColor,
  required text,
  required onPressed,
  required textColor,
  required BuildContext context,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            onPrimary: pressColor,
            primary: primaryColor,
            fixedSize: Size(getWidth(context: context) * .6, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: genericText(text: text, color: textColor),
        );
      } else {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            onPrimary: pressColor,
            primary: primaryColor,
            fixedSize: Size(getWidth(context: context) * .3, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: genericText(text: text, color: textColor),
        );
      }
    },
  );
}

Widget genericButton3({
  required text,
  required icon,
  required onPressed,
  required color,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: color2,
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 5),
              genericText4(
                text: text,
                color: color2,
                stringWeight: FontWeight.w300,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget genericText({required text, required color}) {
  return Text(
    text,
    style: GoogleFonts.oswald(
      fontWeight: FontWeight.w400,
      fontSize: 22,
      color: color,
    ),
    maxLines: 100,
    textAlign: TextAlign.center,
  );
}

Widget genericText2({required text, required color}) {
  return Text(
    text,
    style: GoogleFonts.oswald(
      fontWeight: FontWeight.w200,
      fontSize: 14,
      color: color,
    ),
    maxLines: 5,
    textAlign: TextAlign.center,
  );
}

Widget genericText3({required String text, required Color color}) {
  return Text(
    text,
    style: GoogleFonts.oswald(
      fontWeight: FontWeight.w300,
      fontSize: 28,
      color: color,
    ),
    maxLines: 5,
    textAlign: TextAlign.center,
  );
}

Widget genericText4({
  required String text,
  required Color color,
  required FontWeight stringWeight,
}) {
  return Text(
    text,
    style: GoogleFonts.oswald(
      fontWeight: stringWeight,
      fontSize: 18,
      color: color,
    ),
    maxLines: 5,
    textAlign: TextAlign.center,
    softWrap: true,
  );
}

Widget genericText5({required String text, required Color color}) {
  return Text(
    text,
    style: GoogleFonts.oswald(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: color,
        decoration: TextDecoration.underline),
    maxLines: 5,
    textAlign: TextAlign.center,
  );
}

Widget bigText({required text, required color}) {
  return Text(
    text,
    style: GoogleFonts.oswald(
      fontWeight: FontWeight.w600,
      fontSize: 24,
      color: color,
    ),
  );
}

Future<void> call({required String number}) async {
  final Uri launchUri = Uri(scheme: 'tel', path: number);
  await launchUrl(launchUri);
}

Widget genericRequestRow({
  required title,
  required name,
  required icon,
}) {
  return Row(
    children: [
      icon,
      genericText4(
        text: '$title: ',
        color: color5,
        stringWeight: FontWeight.w400,
      ),
      genericText4(
        text: name,
        color: color5,
        stringWeight: FontWeight.w200,
      ),
    ],
  );
}

Widget circularAvatarImage({
  required networkImage,
  required placeholderIcon,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 70,
      foregroundImage: NetworkImage(networkImage),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(placeholderIcon),
            const SizedBox(height: 15),
            const CircularProgressIndicator(),
          ],
        ),
      ),
      onForegroundImageError: (e, stackTrace) {},
    ),
  );
}

Widget circularAvatarImageSmall({
  required networkImage,
  required placeholderIcon,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 50,
      foregroundImage: NetworkImage(networkImage),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(placeholderIcon),
            const SizedBox(height: 15),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    ),
  );
}

Widget genericExpandableList({
  required name,
  required address,
  required numberC,
  required item,
  required price,
  required notes,
  required pic,
  required BuildContext context,
}) {
  return Container(
    color: Colors.grey[100],
    child: ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          genericRequestRow(
            title: 'Name',
            name: name,
            icon: const Icon(Icons.person_outline),
          ),
          genericRequestRow(
            title: 'Address',
            name: address,
            icon: const Icon(Icons.location_history_outlined),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              genericRequestRow(
                title: 'Number',
                name: numberC.toString(),
                icon: const Icon(
                  Icons.call_outlined,
                ),
              ),
              genericRequestRow(
                title: 'Item',
                name: item,
                icon: const Icon(
                  Icons.store_outlined,
                ),
              ),
              genericRequestRow(
                title: 'Price',
                name: price.toString(),
                icon: const Icon(Icons.attach_money_outlined),
              ),
              genericRequestRow(
                title: 'Notes',
                name: notes,
                icon: const Icon(Icons.textsms_outlined),
              ),
              Row(
                children: [
                  const Icon(Icons.image_outlined),
                  genericText4(
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
                  child: circularAvatarImage(
                    networkImage: pic,
                    placeholderIcon: Icons.catching_pokemon_outlined,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    ),
  );
}

Widget genericExpandableCard({
  required name,
  required address,
  required numberC,
  required item,
  required price,
  required notes,
  required pic,
  required BuildContext context,
}) {
  return Card(
    color: Colors.grey[100],
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          genericRequestRow(
            title: 'Name',
            name: name,
            icon: const Icon(Icons.person_outline),
          ),
          genericRequestRow(
            title: 'Address',
            name: address,
            icon: const Icon(Icons.location_history_outlined),
          ),
          genericRequestRow(
            title: 'Number',
            name: numberC.toString(),
            icon: const Icon(
              Icons.call_outlined,
            ),
          ),
          genericRequestRow(
            title: 'Item',
            name: item,
            icon: const Icon(
              Icons.store_outlined,
            ),
          ),
          genericRequestRow(
            title: 'Price',
            name: price.toString(),
            icon: const Icon(Icons.attach_money_outlined),
          ),
          genericRequestRow(
            title: 'Notes',
            name: notes,
            icon: const Icon(Icons.textsms_outlined),
          ),
          Row(
            children: [
              const Icon(Icons.image_outlined),
              genericText4(
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
              child: circularAvatarImage(
                networkImage: pic,
                placeholderIcon: Icons.catching_pokemon_outlined,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget genericExpandableList2({
  required userId,
  required name,
  required address,
  required numberC,
  required item,
  required price,
  required notes,
  required pic,
  required BuildContext context,
}) {
  return Container(
    color: Colors.grey[100],
    child: ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          genericRequestRow(
            title: 'Name',
            name: name,
            icon: const Icon(Icons.person_outline),
          ),
          genericRequestRow(
            title: 'Address',
            name: address,
            icon: const Icon(Icons.location_history_outlined),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              genericRequestRow(
                title: 'Number',
                name: numberC.toString(),
                icon: const Icon(
                  Icons.call_outlined,
                ),
              ),
              genericRequestRow(
                title: 'Item',
                name: item,
                icon: const Icon(
                  Icons.store_outlined,
                ),
              ),
              genericRequestRow(
                title: 'Price',
                name: price.toString(),
                icon: const Icon(Icons.attach_money_outlined),
              ),
              genericRequestRow(
                title: 'Notes',
                name: notes,
                icon: const Icon(Icons.textsms_outlined),
              ),
              Row(
                children: [
                  const Icon(Icons.image_outlined),
                  genericText4(
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
                  child: circularAvatarImage(
                    networkImage: pic,
                    placeholderIcon: Icons.catching_pokemon_outlined,
                  ),
                ),
              ),
            ],
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditRequests(cname: name),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Icon(
                          Icons.edit_outlined,
                          color: color3,
                        ),
                        const SizedBox(width: 10),
                        genericText4(
                          text: 'Edit',
                          color: color5,
                          stringWeight: FontWeight.w300,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(child: SizedBox()),
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
                    fixedSize: Size(getWidth(context: context) * .8, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Long press to delete entry'),
                      ),
                    );
                  },
                  onLongPress: () async {
                    await CloudService()
                        .deleteSellerRequest(userId: userId, name: name);
                  },
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Icon(
                        Icons.delete_outline,
                        color: color3,
                      ),
                      const SizedBox(width: 10),
                      genericText4(
                        text: 'Delete',
                        color: color5,
                        stringWeight: FontWeight.w300,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget requestsPageShimmer({required BuildContext context}) {
  int currentIndex = 1;
  return Scaffold(
    appBar: AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey[200]!,
        ),
      ),
      title: bigText(
        text: 'My Requests',
        color: color5,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active_outlined),
          color: color5,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size(25, 50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
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
            Row(
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
          ],
        ),
      ),
    ),
    drawer: Container(),
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: shimmerColor,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Skeleton(
                height: 35,
                width: getWidth(context: context) * 0.8,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleSkeleton(size: 100),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Skeleton(
                        height: 25,
                        width: getWidth(context: context) * 0.3,
                      ),
                      const SizedBox(height: 10),
                      Skeleton(
                        height: 25,
                        width: getWidth(context: context) * 0.3,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  const CircleSkeleton(size: 50),
                ],
              ),
              const SizedBox(height: 25),
              Column(
                children: [
                  Skeleton(
                    height: 50,
                    width: getWidth(context: context) * 0.6,
                  ),
                  const SizedBox(height: 10),
                  Skeleton(
                    height: 35,
                    width: getWidth(context: context) * 0.8,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Skeleton(
                        height: 75,
                        width: getWidth(context: context) * 0.8,
                      );
                    },
                    separatorBuilder: ((context, index) {
                      return const SizedBox(height: 15);
                    }),
                    itemCount: 4),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: NavigationBarTheme(
      data: NavigationBarThemeData(
        elevation: 50,
        backgroundColor: Colors.white,
        indicatorColor: color2,
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          currentIndex = index;
        },
        destinations: navyItems,
      ),
    ),
  );
}

Widget textFieldwithIcon({
  required hintText,
  required controller,
  required title,
  required icon,
}) {
  return Column(
    children: [
      Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          genericText(text: title, color: color5),
          const Expanded(child: SizedBox()),
        ],
      ),
      TextField(
        controller: controller,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    ],
  );
}

Widget numberFieldwithIcon({
  required hintText,
  required controller,
  required title,
  required icon,
}) {
  return Column(
    children: [
      Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          genericText(text: title, color: color5),
          const Expanded(child: SizedBox()),
        ],
      ),
      TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    ],
  );
}

Widget textFieldwithIconObscured({
  required hintText,
  required controller,
  required title,
  required icon,
}) {
  return Column(
    children: [
      Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          genericText(text: title, color: color5),
          const Expanded(child: SizedBox()),
        ],
      ),
      TextField(
        controller: controller,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    ],
  );
}

Widget orders({required BuildContext context, required snapshot}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: snapshot.length,
              itemBuilder: (context, index) {
                final price = snapshot[index].data()['price'];
                final name = snapshot[index].data()['name'];
                final item = snapshot[index].data()['item'];
                final notes = snapshot[index].data()['notes'];
                final pic = snapshot[index].data()['picture_url'];
                final numberC = snapshot[index].data()['number'];
                final String address =
                    snapshot[index].data()['address'].split(',')[0];

                return genericExpandableCard(
                    name: name,
                    address: address,
                    numberC: numberC,
                    item: item,
                    price: price,
                    notes: notes,
                    pic: pic,
                    context: context);
              },
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 15,
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.length,
              itemBuilder: (context, index) {
                final price = snapshot[index].data()['price'];
                final name = snapshot[index].data()['name'];
                final item = snapshot[index].data()['item'];
                final notes = snapshot[index].data()['notes'];
                final pic = snapshot[index].data()['picture_url'];
                final numberC = snapshot[index].data()['number'];
                final String address =
                    snapshot[index].data()['address'].split(',')[0];

                return genericExpandableList(
                  name: name,
                  address: address,
                  numberC: numberC,
                  item: item,
                  price: price,
                  notes: notes,
                  pic: pic,
                  context: context,
                );
              },
            ),
          ),
        );
      }
    },
  );
}

Widget driverButton({required driverSnapshot, required BuildContext context}) {
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
            call(number: driverSnapshot['number'].toString());
          },
          child: Row(
            children: [
              circularAvatarImageSmall(
                networkImage: driverSnapshot['picture_url'],
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
                        text: driverSnapshot['name'],
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
                        text: driverSnapshot['city'],
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
            call(number: driverSnapshot['number'].toString());
          },
          child: SizedBox(
            width: getWidth(context: context) * 0.5,
            child: Row(
              children: [
                circularAvatarImageSmall(
                  networkImage: driverSnapshot['picture_url'],
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
                          text: driverSnapshot['name'],
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
                          text: driverSnapshot['city'],
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
        );
      }
    },
  );
}

Widget genericProfileButton(
    {required String field,
    required icon,
    required function,
    required context}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.all(7.5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.grey[100],
              onPrimary: color3,
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: function,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: icon,
                  ),
                  const SizedBox(width: 15),
                  genericText(
                    text: field,
                    color: color5,
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(7.5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.grey[100],
              onPrimary: color3,
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: function,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: getWidth(context: context) * 0.4,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: icon,
                    ),
                    const SizedBox(width: 15),
                    genericText(
                      text: field,
                      color: color5,
                    ),
                    const SizedBox(width: 15),
                    const Expanded(child: SizedBox()),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    },
  );
}
