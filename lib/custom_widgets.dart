import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/constants/colors.dart';

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
    );
  }
}
