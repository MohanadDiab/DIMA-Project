import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/skeleton.dart';
import 'package:url_launcher/url_launcher.dart';

Widget genericButton({
  required primaryColor,
  required pressColor,
  required text,
  required onPressed,
  required textColor,
  required BuildContext context,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      onPrimary: pressColor,
      primary: primaryColor,
      fixedSize: Size(MediaQuery.of(context).size.width * .8, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: onPressed,
    child: genericText(text: text, color: textColor),
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

Widget genericButton2({
  required primaryColor,
  required pressColor,
  required text,
  required textColor,
  required BuildContext context,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      onPrimary: pressColor,
      primary: primaryColor,
      fixedSize: Size(MediaQuery.of(context).size.width * .8, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: () {},
    child: genericText(text: text, color: textColor),
  );
}

Widget box({
  required name,
  required numberOfOrders,
  required context,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color2,
      border: Border.all(color: color4),
      borderRadius: BorderRadius.circular(25),
    ),
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            genericText(
              text: name,
              color: color4,
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        Container(
          height: 2.5,
          color: color4,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            genericText(
              text: '$numberOfOrders Customers',
              color: color4,
            ),
            const Expanded(child: SizedBox()),
            const Icon(Icons.location_on_outlined),
            const SizedBox(
              width: 5,
            ),
            genericText(
              text: 'Milan',
              color: color4,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: genericButton(
              context: context,
              primaryColor: color4,
              pressColor: color2,
              text: 'Request',
              onPressed: () {},
              textColor: color2),
        ),
      ],
    ),
  );
}

Widget box1({
  required name,
  required order,
  required context,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color2,
      borderRadius: BorderRadius.circular(25),
    ),
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            genericText(
              text: name,
              color: color4,
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        Container(
          height: 2.5,
          color: color4,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            genericText(
              text: order,
              color: color4,
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.photo_size_select_actual_rounded),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: genericButton(
              context: context,
              primaryColor: color4,
              pressColor: color2,
              text: 'See location',
              onPressed: () {},
              textColor: color2),
        )
      ],
    ),
  );
}

Widget genericText({required text, required color}) {
  return Text(
    text,
    style: GoogleFonts.oswald(
      fontWeight: FontWeight.w300,
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
        fontWeight: FontWeight.w200,
        fontSize: 18,
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
        Column(
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
        const SizedBox(height: 25),
      ],
    ),
  );
}

Widget requestsPageShimmer({required BuildContext context}) {
  return SafeArea(
    child: Scaffold(
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
                  width: MediaQuery.of(context).size.width * 0.8,
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
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                        const SizedBox(height: 10),
                        Skeleton(
                          height: 25,
                          width: MediaQuery.of(context).size.width * 0.3,
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
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(height: 10),
                    Skeleton(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.8,
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
                          width: MediaQuery.of(context).size.width * 0.8,
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
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            _currentIndex = index;
          },
          destinations: _navyItems,
        ),
      ),
    ),
  );
}

int _currentIndex = 1;

const _navyItems = <NavigationDestination>[
  NavigationDestination(icon: Icon(Icons.map), label: 'orders'),
  NavigationDestination(icon: Icon(Icons.shop), label: 'Requests'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
];

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
