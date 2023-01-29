import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/services/cloud/cloud_storage.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.userId,
    required this.itemId,
  });

  final CameraDescription camera;
  final String userId;
  final String itemId;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? userId;
  String? itemId;
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    userId = widget.userId;
    itemId = widget.itemId;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                  userId: userId!,
                  itemId: itemId!,
                ),
              ),
            )
                .then((ifFinished) {
              if (ifFinished) {
                Navigator.of(context).pop();
              }
            });
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.userId,
    required this.itemId,
  });

  final CloudStorage storage = CloudStorage();
  final String userId;
  final String itemId;

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Image.file(File(imagePath)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            storage.uploadImage(
                fileName: '${userId}_$itemId', filePath: imagePath);
            storage
                .getImageURL(imageName: '${userId}_$itemId')
                .then((pictureURL) {
              if (pictureURL != null &&
                  pictureURL != 'there has been an error') {
                CloudService().addDeliveredImage(
                    userId: userId, itemId: itemId, pictureUrl: pictureURL);
                showDialog<Null>(
                  context: _context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('successfully uploaded!'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(_context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                ).then((val) {
                  print(val);
                });
              } else {
                showDialog<Null>(
                  context: _context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('fail to upload!'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('fail to upload!'),
                            Text('please check your internet connection'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                ).then((val) {
                  print(val);
                });
              }
            });
            print(imagePath);
          },
          child: const Icon(Icons.cloud_upload),
        ));
  }
}
