import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/skeleton.dart';
import 'package:url_launcher/url_launcher.dart';

class GenericButton extends StatelessWidget {
  const GenericButton({
    Key? key,
    required this.primaryColor,
    required this.pressColor,
    required this.text,
    required this.onPressed,
    required this.textColor,
  }) : super(key: key);

  final Color primaryColor;
  final Color pressColor;
  final Color textColor;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
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
      child: GenericText(text: text, color: textColor),
    );
  }
}

class GenericButton3 extends StatelessWidget {
  const GenericButton3({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  final String text;
  final Color color;
  final Widget icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
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
}

class GenericButton2 extends StatelessWidget {
  const GenericButton2({
    Key? key,
    required this.primaryColor,
    required this.pressColor,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  final Color primaryColor;
  final Color pressColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
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
      child: GenericText(text: text, color: textColor),
    );
  }
}

class Box extends StatelessWidget {
  const Box({Key? key, required this.name, required this.numberOfOrders})
      : super(key: key);

  final String name;
  final int numberOfOrders;

  @override
  Widget build(BuildContext context) {
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
              GenericText(
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
              GenericText(
                text: '$numberOfOrders Customers',
                color: color4,
              ),
              const Expanded(child: SizedBox()),
              const Icon(Icons.location_on_outlined),
              const SizedBox(
                width: 5,
              ),
              GenericText(
                text: 'Milan',
                color: color4,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GenericButton(
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
}

class Box1 extends StatelessWidget {
  const Box1({
    Key? key,
    required this.name,
    required this.order,
  }) : super(key: key);

  final String name;
  final String order;

  @override
  Widget build(BuildContext context) {
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
              GenericText(
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
              GenericText(
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
            child: GenericButton(
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
}

class GenericText extends StatelessWidget {
  const GenericText({Key? key, required this.text, required this.color})
      : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.oswald(
        fontWeight: FontWeight.w300,
        fontSize: 22,
        color: color,
      ),
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }
}

class GenericText2 extends StatelessWidget {
  const GenericText2({Key? key, required this.text, required this.color})
      : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
        fontSize: 14,
        color: color,
        decoration: TextDecoration.underline),
    maxLines: 5,
    textAlign: TextAlign.center,
  );
}

class BigText extends StatelessWidget {
  const BigText({Key? key, required this.text, required this.color})
      : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.oswald(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: color,
      ),
    );
  }
}

Future<void> call({required String number}) async {
  final Uri launchUri = Uri(scheme: 'tel', path: number);
  await launchUrl(launchUri);
}

class GenericRequestRow extends StatelessWidget {
  const GenericRequestRow({
    Key? key,
    required this.title,
    required this.name,
    required this.icon,
  }) : super(key: key);
  final String title;
  final String name;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
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
}

class CircularAvatarImage extends StatelessWidget {
  const CircularAvatarImage({
    Key? key,
    required this.networkImage,
    required this.placeholderIcon,
  }) : super(key: key);

  final String networkImage;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
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
}

class CircularAvatarImageSmall extends StatelessWidget {
  const CircularAvatarImageSmall(
      {Key? key, required this.networkImage, required this.placeholderIcon})
      : super(key: key);

  final String networkImage;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
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
}

class GenericExpandableList extends StatelessWidget {
  const GenericExpandableList({
    Key? key,
    required this.name,
    required this.address,
    required this.numberC,
    required this.item,
    required this.price,
    required this.notes,
    required this.pic,
  }) : super(key: key);
  final String name;
  final String address;
  final int numberC;
  final String item;
  final double price;
  final String notes;
  final String pic;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            GenericRequestRow(
              title: 'Name',
              name: name,
              icon: const Icon(Icons.person_outline),
            ),
            GenericRequestRow(
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
              GenericRequestRow(
                title: 'Number',
                name: numberC.toString(),
                icon: const Icon(
                  Icons.call_outlined,
                ),
              ),
              GenericRequestRow(
                title: 'Item',
                name: item,
                icon: const Icon(
                  Icons.store_outlined,
                ),
              ),
              GenericRequestRow(
                title: 'Price',
                name: price.toString(),
                icon: const Icon(Icons.attach_money_outlined),
              ),
              GenericRequestRow(
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
                  child: CircularAvatarImage(
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
}

Widget requestsPageShimmer(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: shimmerColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircleSkeleton(size: 50),
                    Expanded(child: SizedBox()),
                    Skeleton(
                      height: 40,
                      width: 200,
                    ),
                    Expanded(child: SizedBox()),
                    CircleSkeleton(size: 50),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Skeleton(
                      height: 40,
                      width: 150,
                    ),
                    Skeleton(
                      height: 40,
                      width: 150,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
                      itemCount: 7),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
