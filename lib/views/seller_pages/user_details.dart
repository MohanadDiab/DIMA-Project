import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/services/cloud/cloud_storage.dart';
import 'package:http/http.dart';

class EditUserDetailsSeller extends StatefulWidget {
  const EditUserDetailsSeller({Key? key}) : super(key: key);
  @override
  State<EditUserDetailsSeller> createState() => _EditUserDetailsSellerState();
}

class _EditUserDetailsSellerState extends State<EditUserDetailsSeller> {
  _EditUserDetailsSellerState();

  String userId = FirebaseAuth.instance.currentUser!.uid;
  final CloudStorage storage = CloudStorage();
  late final TextEditingController _nameTextController;
  late final TextEditingController _cityTextController;

  late final TextEditingController _numberTextController;

  @override
  void initState() {
    _nameTextController = TextEditingController();
    _cityTextController = TextEditingController();

    _numberTextController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _cityTextController.dispose();
    _numberTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: BigText(text: 'User Details', color: color5),
        ),
        body: FutureBuilder(
          future: CloudService().getSellerProfile(userId: userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                _nameTextController.text = snapshot.data['name'];
                _numberTextController.text =
                    (snapshot.data['number']).toString();
                _cityTextController.text = snapshot.data['city'].toString();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Lottie.asset('assets/profile.json'),
                        GenericText(text: 'Update your account', color: color5),
                        GenericText2(
                            text:
                                'Note: updating your city may affect the driver traffic.',
                            color: color5),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: 2.5,
                            color: Colors.grey[200],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person),
                                  const SizedBox(width: 10),
                                  GenericText(text: 'Name', color: color5),
                                ],
                              ),
                              TextField(
                                controller: _nameTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Your first and lastname',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.numbers),
                                  const SizedBox(width: 10),
                                  GenericText(text: 'Number', color: color5),
                                ],
                              ),
                              TextField(
                                controller: _numberTextController,
                                decoration: const InputDecoration(
                                  hintText: 'Your number',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_city),
                                  const SizedBox(width: 10),
                                  GenericText(
                                      text: 'City of residence', color: color5),
                                ],
                              ),
                              TextField(
                                controller: _cityTextController,
                                decoration: const InputDecoration(
                                  hintText: 'City you live in',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: GenericButton(
                            primaryColor: color3,
                            pressColor: color2,
                            text: 'Save',
                            onPressed: () {
                              CloudService().updateSellerProfile(
                                userId: userId,
                                name: _nameTextController.text,
                                number: _numberTextController.text,
                                city: _cityTextController.text,
                              );
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'Account updated successfully',
                                ),
                              ));
                            },
                            textColor: color2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}
