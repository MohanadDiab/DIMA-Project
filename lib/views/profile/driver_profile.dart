import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/utilities/dialogs/logout_dialog.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({Key? key}) : super(key: key);

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 150,
              color: color3,
            ),
            Expanded(
              child: Container(
                color: color2,
              ),
            ),
          ],
        ),
        Center(
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_back_ios,
                color: color3,
              ),
            ],
          ),
        ),
        ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mohanad Diab',
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: color2,
                          ),
                        ),
                        Text(
                          'Deliveryman Account',
                          style: GoogleFonts.oswald(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: color2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: color4,
                      width: 5,
                    ),
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/intro screen.jpg'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Settings',
                  style: GoogleFonts.oswald(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 5,
                  color: color4,
                ),
                const SizedBox(
                  height: 20,
                ),
                GenericButton(
                  primaryColor: color4,
                  pressColor: color3,
                  text: 'Edit info',
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                GenericButton(
                  primaryColor: color4,
                  pressColor: color3,
                  text: 'Change language',
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                GenericButton(
                  primaryColor: color4,
                  pressColor: color3,
                  text: 'Sign out',
                  onPressed: () async {
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class GenericButton extends StatelessWidget {
  const GenericButton({
    Key? key,
    required this.primaryColor,
    required this.pressColor,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final Color primaryColor;
  final Color pressColor;
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
      child: Text(
        text,
        style: GoogleFonts.oswald(
          fontWeight: FontWeight.w500,
          fontSize: 24,
          color: color2,
        ),
      ),
    );
  }
}
