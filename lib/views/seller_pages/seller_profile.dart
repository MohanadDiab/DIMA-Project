import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/utilities/dialogs/logout_dialog.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({Key? key}) : super(key: key);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

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
        FutureBuilder(
          future: DriverCloud().getSellerProfile(userId: userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case (ConnectionState.done):
                return ListView(
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
                                GenericText(
                                  text: snapshot.data['name'],
                                  color: color2,
                                ),
                                GenericText(
                                  text: 'Seller Account',
                                  color: color2,
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
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data['picture_url']),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GenericText(
                          text: 'Settings',
                          color: color4,
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
                          textColor: color2,
                          text: 'Edit info',
                          onPressed: () {
                            DriverCloud().createDriverProfile(
                              userId: userId,
                              name: 'Mohanad Diab',
                              city: 'Amman',
                              number: 0790389008,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GenericButton(
                          primaryColor: color4,
                          pressColor: color3,
                          textColor: color2,
                          text: 'Change language',
                          onPressed: () {
                            final user = FirebaseAuth.instance.currentUser;
                            print(user.toString());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GenericButton(
                          primaryColor: color4,
                          pressColor: color3,
                          textColor: color2,
                          text: 'Sign out',
                          onPressed: () async {
                            final shouldLogout =
                                await showLogOutDialog(context);
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
                );

              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
