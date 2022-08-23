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
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: color,
      ),
      maxLines: 2,
      textAlign: TextAlign.center,
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
        fontWeight: FontWeight.w300,
        fontSize: 16,
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
        fontWeight: FontWeight.w500,
        fontSize: 30,
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
        fontSize: 20,
        color: color,
      ),
      maxLines: 5,
      textAlign: TextAlign.center,
      softWrap: true,
    );
  }
}

Future<void> call({required String number}) async {
  final Uri launchUri = Uri(scheme: 'tel', path: number);
  await launchUrl(launchUri);
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
          fontWeight: FontWeight.w300,
          fontSize: 16,
          color: color,
          decoration: TextDecoration.underline),
      maxLines: 5,
      textAlign: TextAlign.center,
    );
  }
}
