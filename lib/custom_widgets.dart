import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/constants/colors.dart';
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
                GenericText4(
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

class GenericText3 extends StatelessWidget {
  const GenericText3({Key? key, required this.text, required this.color})
      : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
}

class GenericText4 extends StatelessWidget {
  const GenericText4(
      {Key? key,
      required this.text,
      required this.color,
      required this.stringWeight})
      : super(key: key);

  final String text;
  final Color color;
  final FontWeight stringWeight;

  @override
  Widget build(BuildContext context) {
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
}

class GenericText5 extends StatelessWidget {
  const GenericText5({Key? key, required this.text, required this.color})
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
          decoration: TextDecoration.underline),
      maxLines: 5,
      textAlign: TextAlign.center,
    );
  }
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
        GenericText4(
          text: '$title: ',
          color: color5,
          stringWeight: FontWeight.w400,
        ),
        GenericText4(
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
                  GenericText4(
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
