import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/url.dart';
import 'package:testapp/utilities/show_snackbar.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/services/cloud/cloud_storage.dart';
import 'package:testapp/utilities/dialogs/logout_dialog.dart';
import 'package:testapp/views/common_pages/help_and_support.dart';
import 'package:testapp/views/driver_pages/driver_user_details.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({Key? key}) : super(key: key);

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile>
    with AutomaticKeepAliveClientMixin {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final CloudStorage storage = CloudStorage();

  late String storageName;

  Future pickingImage({
    required String userId,
  }) async {
    final imageResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );
    if (imageResult == null) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Kindly upload a valid image");
      return null;
    }
    final filePath = imageResult.files.single.path!;
    storageName = userId;
    storage.uploadImage(fileName: storageName, filePath: filePath);
    final pictureURL = await storage.getImageURL(imageName: storageName);
    CloudService().uploadDriverImage(
      userId: userId,
      pictureUrl: pictureURL!,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CloudService().getDriverProfile(userId: userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.waiting):
            return const Center(
              child: CircularProgressIndicator(),
            );
          case (ConnectionState.done):
            var pic = snapshot.data['picture_url'];
            pic ??= profilePlaceholderImage;
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
                title: bigText(
                  text: 'Your account',
                  color: color5,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      circularAvatarImage(
                        networkImage: pic,
                        placeholderIcon: Icons.person,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          primary: Colors.white,
                          onPrimary: color3,
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                              color: Colors.grey[200]!,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          pickingImage(userId: userId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: genericText2(
                            text: 'Change picture',
                            color: color5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            genericText(
                              text: snapshot.data['name'],
                              color: color5,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const SizedBox(width: 5),
                                genericText2(
                                  text: snapshot.data['city'],
                                  color: color5,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                height: 2.5,
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                genericProfileButton(
                                  context: context,
                                  field: 'User Details',
                                  icon: Icon(
                                    Icons.person,
                                    color: color5,
                                  ),
                                  function: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const EditUserDetailsDriver(),
                                      ),
                                    );
                                  },
                                ),
                                genericProfileButton(
                                  context: context,
                                  field: 'Help & Support',
                                  icon: Icon(
                                    Icons.help_center,
                                    color: color5,
                                  ),
                                  function: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const HelpAndSupportView(),
                                      ),
                                    );
                                  },
                                ),
                                genericProfileButton(
                                  context: context,
                                  field: 'Privacy Policy',
                                  icon: Icon(
                                    Icons.verified_user_outlined,
                                    color: color5,
                                  ),
                                  function: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://www.termsfeed.com/live/3f0f2c07-67bb-4085-9291-be39e2585ada"),
                                    );
                                  },
                                ),
                                genericProfileButton(
                                  context: context,
                                  field: 'Logout',
                                  icon: Icon(
                                    Icons.logout_outlined,
                                    color: color5,
                                  ),
                                  function: () async {
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
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    genericProfileButton(
                                      context: context,
                                      field: 'User Details',
                                      icon: Icon(
                                        Icons.person,
                                        color: color5,
                                      ),
                                      function: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const EditUserDetailsDriver(),
                                          ),
                                        );
                                      },
                                    ),
                                    genericProfileButton(
                                      context: context,
                                      field: 'Help & Support',
                                      icon: Icon(
                                        Icons.help_center,
                                        color: color5,
                                      ),
                                      function: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const HelpAndSupportView(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    genericProfileButton(
                                      context: context,
                                      field: 'Privacy Policy',
                                      icon: Icon(
                                        Icons.verified_user_outlined,
                                        color: color5,
                                      ),
                                      function: () {
                                        launchUrl(
                                          Uri.parse(
                                              "https://www.termsfeed.com/live/3f0f2c07-67bb-4085-9291-be39e2585ada"),
                                        );
                                      },
                                    ),
                                    genericProfileButton(
                                      context: context,
                                      field: 'Logout',
                                      icon: Icon(
                                        Icons.logout_outlined,
                                        color: color5,
                                      ),
                                      function: () async {
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
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }

