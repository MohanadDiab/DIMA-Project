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
    return FutureBuilder(
      future: CloudService().getSellerProfile(userId: userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.waiting):
            return const Center(
              child: CircularProgressIndicator(),
            );
          case (ConnectionState.done):
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                  ),
                ),
                title: BigText(
                  text: 'Your account',
                  color: color5,
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                    color: Colors.black,
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  NetworkImage(snapshot.data['picture_url']),
                            ),
                            const SizedBox(width: 40),
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GenericText(
                                    text: snapshot.data['name'],
                                    color: color5,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.white,
                                      onPrimary: color3,
                                      padding: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        side: BorderSide(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: GenericText2(
                                      text: 'Edit profile',
                                      color: color5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 52),
                        Container(
                          height: 2.5,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GenericText(text: 'Name', color: color5),
                          const TextField(
                            keyboardType: TextInputType.streetAddress,
                            // controller: _locationTextController,
                            decoration: InputDecoration(
                              hintText: 'Prefer first and lastname only',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
