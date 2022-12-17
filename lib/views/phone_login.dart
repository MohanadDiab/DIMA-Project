import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/services/auth/alt_auth_providers.dart';
import 'package:testapp/widgets/custom_widgets.dart';

class PhoneScreen extends StatefulWidget {
  static String routeName = '/phone';
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: color5,
        title: bigText(
          text: "Sign in with phone number",
          color: color5,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icon/icon.png'),
                  ),
                ),
              ),
              bigText(
                text: 'Delevery',
                color: color3,
              ),
              genericText(text: "Welcome back!", color: color5),
              const SizedBox(height: 10),
              Container(
                height: 1,
                color: color3,
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(15),
                child: numberFieldwithIcon(
                  title: "Phone number",
                  icon: Icons.phone,
                  controller: phoneController,
                  hintText: 'eg. +393511111111',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: genericButton(
                    primaryColor: color3,
                    pressColor: color2,
                    text: "Let's go",
                    onPressed: () {
                      context
                          .read<FirebaseAuthMethods>()
                          .phoneSignIn(context, phoneController.text);
                    },
                    textColor: color2,
                    context: context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
