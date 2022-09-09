import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/auth/auth_service.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/services/cloud/cloud_storage.dart';
import 'package:http/http.dart';
import 'package:testapp/services/misc/passsword_generator.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final CloudStorage storage = CloudStorage();

  late final TextEditingController _nameTextController;
  late final TextEditingController _itemTextController;
  late final TextEditingController _emailTextController;

  late final TextEditingController _priceTextController;
  late final TextEditingController _notesTextController;
  late final TextEditingController _numberTextController;
  late final TextEditingController _locationTextController;
  late final TextEditingController _imageTextController;
  double lat = 0;
  double long = 0;
  bool isVisible = true;
  String storageName = '';

  late final String imageName;
  List<dynamic> _placesList = [];

  @override
  void initState() {
    _nameTextController = TextEditingController();
    _itemTextController = TextEditingController();
    _priceTextController = TextEditingController();
    _notesTextController = TextEditingController();
    _numberTextController = TextEditingController();
    _locationTextController = TextEditingController();
    _imageTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _locationTextController.addListener(() {
      onChange();
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _itemTextController.dispose();
    _priceTextController.dispose();
    _emailTextController.dispose();
    _notesTextController.dispose();
    _numberTextController.dispose();
    _locationTextController.dispose();
    _imageTextController.dispose();

    super.dispose();
  }

  void onChange() {
    isVisible = true;
    getSuggestion(_locationTextController.text);
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

  Future<void> savingCustomerInfo({
    required TextEditingController nameController,
    required TextEditingController itemController,
    required TextEditingController notesController,
    required TextEditingController numberController,
    required TextEditingController locationController,
    required TextEditingController priceController,
    required TextEditingController emailController,
    required double lat,
    required double long,
  }) async {
    try {
      final pictureURL = await storage.getImageURL(imageName: storageName);

      await CloudService().createUpdateRequest(
        email: emailController.text,
        price: double.parse(priceController.text),
        address: locationController.text,
        userId: userId,
        name: nameController.text,
        item: itemController.text,
        number: int.parse(numberController.text),
        notes: notesController.text,
        lat: lat,
        long: long,
        pictureUrl: pictureURL!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request created successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kindly fill out all the fields'),
        ),
      );
    }
  }

  Future<String?> pickingImage(
      {required String userId, required String name}) async {
    final imageResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );
    if (imageResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kindly fill out all the fields'),
        ),
      );
      return null;
    }
    final filePath = imageResult.files.single.path!;
    final fileName = imageResult.files.single.name;
    storageName = '$userId$name';
    storage.uploadImage(fileName: storageName, filePath: filePath);
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color3,
          elevation: 0,
          centerTitle: true,
          title: GenericText(
            text: 'New Request',
            color: color2,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              GenericText(
                text: 'Enter the customer details below',
                color: color3,
              ),
              Lottie.asset('assets/package.json'),
              Container(
                height: 2.5,
                width: MediaQuery.of(context).size.width * .75,
                color: color3,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: GenericText2(
                    text:
                        'Note: in order to provide the user with the best experience, it is mandatory to fill all the fields below.',
                    color: color3),
              ),
              Container(
                height: 2.5,
                width: MediaQuery.of(context).size.width * .75,
                color: color3,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenericText(text: 'Name', color: color5),
                    TextField(
                      controller: _nameTextController,
                      decoration: const InputDecoration(
                        hintText: 'Customer Name',
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
                    GenericText(text: 'Email', color: color5),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
                      decoration: const InputDecoration(
                        hintText: 'Customer email address',
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
                    GenericText(text: 'Item name', color: color5),
                    TextField(
                      controller: _itemTextController,
                      decoration: const InputDecoration(
                        hintText: 'Name of the item',
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
                    GenericText(text: 'Item price', color: color5),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _priceTextController,
                      decoration: const InputDecoration(
                        hintText: 'Price of the item',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: GenericText2(
                    text:
                        'Note: a delivery price will be added later, enter the original price of the item.',
                    color: color3),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenericText(text: 'Deilivery notes', color: color5),
                    TextField(
                      controller: _notesTextController,
                      decoration: const InputDecoration(
                        hintText: 'Notes to the driver',
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
                    GenericText(text: 'Delivery address', color: color5),
                    TextField(
                      keyboardType: TextInputType.streetAddress,
                      controller: _locationTextController,
                      decoration: const InputDecoration(
                        hintText: 'Please provide the city and street name',
                      ),
                    ),
                  ],
                ),
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
                          List<Location> locations = await locationFromAddress(
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
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenericText(text: 'Customer number', color: color5),
                    TextField(
                      keyboardType: TextInputType.phone,
                      controller: _numberTextController,
                      decoration: const InputDecoration(
                        hintText: 'Phone or home number',
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
                    GenericText(
                        text: 'Upload an image of the item', color: color5),
                    const SizedBox(height: 15),
                    Row(children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          onPrimary: color3,
                          primary: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          final name = _nameTextController.text;
                          final imageName =
                              await pickingImage(name: name, userId: userId);
                          _imageTextController.text =
                              imageName ?? 'no image chosen';
                        },
                        child: GenericText2(
                            text: 'Choose from files', color: color5),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: SizedBox(
                          child: TextField(
                            enabled: false,
                            keyboardType: TextInputType.phone,
                            controller: _imageTextController,
                            decoration: const InputDecoration(
                              hintText: 'Image name will show here',
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              GenericButton(
                primaryColor: color3,
                pressColor: color2,
                text: 'Save order',
                onPressed: () async {
                  savingCustomerInfo(
                    emailController: _emailTextController,
                    priceController: _priceTextController,
                    locationController: _locationTextController,
                    nameController: _nameTextController,
                    itemController: _itemTextController,
                    notesController: _notesTextController,
                    numberController: _numberTextController,
                    lat: lat,
                    long: long,
                  );
                  Navigator.of(context).pop();

                  // final buyerPassword = generatePassword();
                  // AuthService.firebase().createUser(
                  //   email: _emailTextController.text,
                  //   password: buyerPassword,
                  // );
                  // final Email email = Email(
                  //   body:
                  //       'Hello and welcome to Delever\n an account has been created with this account\n to check your order status kindly login to the account with this following random password\n Password: $buyerPassword',
                  //   subject: 'Your order is in good hands with Delever',
                  //   recipients: [_emailTextController.text],
                  //   isHTML: false,
                  // );
                  // await FlutterEmailSender.send(email);
                  // await CloudService().createBuyerProfile(
                  //   name: _nameTextController.text,
                  //   email: _emailTextController.text,
                  // );
                },
                textColor: color2,
              ),
              const SizedBox(height: 25),
              GenericText2(
                  text: "Once you save the order it will be final.",
                  color: color3),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
