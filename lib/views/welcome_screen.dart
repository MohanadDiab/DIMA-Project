import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/utilities/dialogs/logout_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 75),
            Lottie.asset('assets/animation.json'),
            GenericText3(text: 'Welcome to Delever', color: color5),
            const SizedBox(height: 25),
            Container(
              height: 2.5,
              width: 250,
              color: color3,
            ),
            const SizedBox(height: 25),
            FutureBuilder(
              future: DriverCloud().isDriver(userId: userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case (ConnectionState.waiting):
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case (ConnectionState.done):
                    return GenericButton(
                        primaryColor: color3,
                        pressColor: color3,
                        text: 'Continue to app',
                        onPressed: () {
                          if (snapshot.data) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              driverUI,
                              (route) => false,
                            );
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              sellerUI,
                              (route) => false,
                            );
                          }
                        },
                        textColor: color2);
                  default:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                }
              },
            ),
            const SizedBox(height: 25),
            GenericButton(
              primaryColor: color3,
              pressColor: color3,
              textColor: color2,
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
            const Expanded(child: SizedBox()),
            GenericText2(text: 'Version number:1.00', color: color4),
            GenericText2(text: 'Build number:1.00', color: color4),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
