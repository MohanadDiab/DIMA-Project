import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

class HelpAndSupportView extends StatefulWidget {
  const HelpAndSupportView({Key? key}) : super(key: key);

  @override
  State<HelpAndSupportView> createState() => _HelpAndSupportViewState();
}

class _HelpAndSupportViewState extends State<HelpAndSupportView> {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  late final TextEditingController _emailTextController;
  late final TextEditingController _subjectTextController;

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _subjectTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _subjectTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: BigText(text: 'Help & Support', color: color5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericText(
                        text: 'Frequently asked questions:',
                        color: color5,
                      ),
                      const SizedBox(height: 15),
                      genericText4(
                        text: q1,
                        color: color5,
                        stringWeight: FontWeight.w300,
                      ),
                      genericText4(
                        text: a1,
                        color: color5,
                        stringWeight: FontWeight.w200,
                      ),
                      const SizedBox(height: 15),
                      genericText4(
                        text: q2,
                        color: color5,
                        stringWeight: FontWeight.w300,
                      ),
                      genericText4(
                        text: a2,
                        color: color5,
                        stringWeight: FontWeight.w200,
                      ),
                      const SizedBox(height: 15),
                      genericText4(
                        text: q3,
                        color: color5,
                        stringWeight: FontWeight.w300,
                      ),
                      genericText4(
                        text: a3,
                        color: color5,
                        stringWeight: FontWeight.w200,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericText(text: 'Contact us:', color: color5),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.email),
                          const SizedBox(width: 10),
                          GenericText(text: 'Email', color: color5),
                        ],
                      ),
                      TextField(
                        keyboardType: TextInputType.streetAddress,
                        controller: _emailTextController,
                        decoration: const InputDecoration(
                          hintText: 'Please provide your email',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.text_fields_rounded),
                          const SizedBox(width: 10),
                          GenericText(text: 'Subject', color: color5),
                        ],
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _subjectTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Please enter anything on your mind here reagrding the app',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: GenericButton(
                          primaryColor: color3,
                          pressColor: color2,
                          text: 'Send',
                          onPressed: () {
                            if (_emailTextController.text.isEmpty &&
                                _subjectTextController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Kindly provide the email and a subject to send a support request'),
                                ),
                              );
                            } else {
                              CloudService().createSellerSupportRequest(
                                userId: userId,
                                email: _emailTextController.text,
                                subject: _subjectTextController.text,
                              );
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Request sent successfully'),
                                ),
                              );
                            }
                          },
                          textColor: color2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String q1 = "Q: I can't see any requests:";
const String q2 = "Q:I can't add any new requests";
// ignore: unnecessary_string_escapes
const String q3 =
    "Q:I am trying to contact the driver\seller but can't get a response";

const String a1 =
    "A: This is a common issue if your internet connection is not stable, kindly try to exit the app and enter again. if that doesn't work try to logout and login.\n If the problem persists, kindly contact the customer service via the contact us service below.";

const String a2 =
    "A: If you can't add or accept new requests, it's probable cause is that you performed a previous transaction with unstable internet connection and the connection timed out without notiying the server, kindly try to refresh the app to try and resolve the issue.";
// ignore: unnecessary_string_escapes

const String a3 =
    "A: If the other party is not completing their assigned tasks and not replying to communication, kindly contact the customer service in order to reassign\cancel the order";
