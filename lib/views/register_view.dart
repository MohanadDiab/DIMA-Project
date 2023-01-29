import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/extensions/buildcontext/loc.dart';
import 'package:testapp/services/auth/auth_exceptions.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/auth/bloc/auth_state.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/utilities/dialogs/error_dialog.dart';
import 'package:http/http.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_weak_password,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_email_already_in_use,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_generic,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_invalid_email,
            );
          }
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: color5,
            title: bigText(text: "Choose your register type", color: color3),
            bottom: TabBar(tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sell_outlined, color: color3),
                    const SizedBox(width: 10),
                    genericText(text: "Seller", color: color5),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delivery_dining_outlined, color: color3),
                    const SizedBox(width: 10),
                    genericText(text: "Driver", color: color5),
                  ],
                ),
              ),
            ]),
          ),
          body: const TabBarView(
            children: [
              RegisterTabSeller(),
              RegisterTabDriver(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterTabSeller extends StatefulWidget {
  const RegisterTabSeller({Key? key}) : super(key: key);

  @override
  State<RegisterTabSeller> createState() => _RegisterTabSellerState();
}

class _RegisterTabSellerState extends State<RegisterTabSeller> {
  late final TextEditingController _email;

  late final TextEditingController _password;

  late final TextEditingController _name;

  late final TextEditingController _city;

  late final TextEditingController _number;

  late final TextEditingController _locationTextController;

  List<dynamic> _placesList = [];
  bool isVisible = true;
  double lat = 0;
  double long = 0;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _number = TextEditingController();
    _city = TextEditingController();
    _locationTextController = TextEditingController();
    _locationTextController.addListener(() {
      onChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _city.dispose();
    _number.dispose();
    super.dispose();
  }

  void getSuggestion(String input) async {
    const String KAPIKey = 'AIzaSyAktuBhmVOtCZN12HIOe3mSkJMit0Oqs04';
    const baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final request = '$baseURL?input=$input&key=$KAPIKey';
    var response = await get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void onChange() {
    isVisible = true;
    getSuggestion(_locationTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Column(children: [
                genericText(
                    text: "Please provide your information below",
                    color: color3),
                genericText4(
                  text:
                      "Note: For a better experience, all fields below are mandatory.",
                  color: color5,
                  stringWeight: FontWeight.w300,
                ),
                const Divider(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 15, 50, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  registerFields(
                      nameController: _name,
                      emailController: _email,
                      passwordController: _password,
                      cityController: _city,
                      numberController: _number),
                  textFieldwithIcon(
                    hintText: "Please provide the city and street name",
                    controller: _locationTextController,
                    title: 'Address',
                    icon: Icons.door_front_door,
                  ),
                  Visibility(
                    visible: isVisible,
                    child: SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _placesList.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            onTap: (() async {
                              print(_placesList);
                              List<Location> locations =
                                  await locationFromAddress(
                                      _placesList[index]['description']);
                              long = locations.last.longitude;
                              lat = locations.last.latitude;
                              _locationTextController.text =
                                  _placesList[index]['description'];
                              isVisible = false;
                            }),
                            title: Text(_placesList[index]['description']),
                          );
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: genericButton(
                        context: context,
                        primaryColor: color3,
                        pressColor: color2,
                        text: context.loc.register,
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          final city = _city.text;
                          final number = _number.text;
                          final name = _name.text;
                          final location = _locationTextController.text;
                          final userCredentials = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final userId = userCredentials.user!.uid;
                          await CloudService().createSellerProfile(
                              userId: userId,
                              name: name,
                              city: city,
                              number: int.parse(number),
                              address: location,
                              lat: lat,
                              lng: long);
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        textColor: color2),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: genericText5(
                      text: context.loc.forgot_password_view_back_to_login,
                      color: color5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterTabDriver extends StatefulWidget {
  const RegisterTabDriver({Key? key}) : super(key: key);

  @override
  State<RegisterTabDriver> createState() => _RegisterTabDriverState();
}

class _RegisterTabDriverState extends State<RegisterTabDriver> {
  late final TextEditingController _email;

  late final TextEditingController _password;

  late final TextEditingController _name;

  late final TextEditingController _city;

  late final TextEditingController _number;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _number = TextEditingController();
    _city = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _city.dispose();
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: Column(children: [
                genericText(
                    text: "Please provide your information below",
                    color: color3),
                genericText4(
                  text:
                      "Note: For a better experience, all fields below are mandatory.",
                  color: color5,
                  stringWeight: FontWeight.w300,
                ),
                const Divider(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 15, 50, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  registerFields(
                    emailController: _email,
                    passwordController: _password,
                    cityController: _city,
                    numberController: _number,
                    nameController: _name,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: genericButton(
                        context: context,
                        primaryColor: color3,
                        pressColor: color2,
                        text: context.loc.register,
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          final city = _city.text;
                          final number = _number.text;
                          final name = _name.text;
                          final userCredentials = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final userId = userCredentials.user!.uid;
                          await CloudService().createDriverProfile(
                            userId: userId,
                            name: name,
                            city: city,
                            number: int.parse(number),
                          );
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        textColor: color2),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    child: genericText5(
                      text: context.loc.forgot_password_view_back_to_login,
                      color: color5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget registerFields({
  required emailController,
  required passwordController,
  required cityController,
  required numberController,
  required nameController,
}) {
  return Column(
    children: [
      textFieldwithIcon(
        hintText: "Enter your first and lastname only",
        controller: nameController,
        title: 'Name',
        icon: Icons.person_outline,
      ),
      const SizedBox(height: 25),
      textFieldwithIcon(
        hintText: "Enter your email here",
        controller: emailController,
        title: 'Email address',
        icon: Icons.email_outlined,
      ),
      const SizedBox(height: 25),
      textFieldwithIconObscured(
        hintText: "Enter your password here",
        controller: passwordController,
        title: 'Password',
        icon: Icons.lock_outlined,
      ),
      const SizedBox(height: 25),
      numberFieldwithIcon(
        hintText: "Enter your number here",
        controller: numberController,
        title: 'Number',
        icon: Icons.call_outlined,
      ),
      const SizedBox(height: 25),
      textFieldwithIcon(
        hintText: "Enter your city name here",
        controller: cityController,
        title: 'City',
        icon: Icons.location_city_outlined,
      ),
      const SizedBox(height: 25),
    ],
  );
}
