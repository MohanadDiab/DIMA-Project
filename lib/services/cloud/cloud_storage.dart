import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testapp/services/cloud/cloud_storage_exceptions.dart';

class CloudStorage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadImage(
      {required String fileName, required String filePath}) async {
    File file = File(filePath);
    try {
      await storage.ref('items/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      throw AnErrorHasOccured();
    }
  }

  Future<String?> getImageURL({required String imageName}) async {
    try {
      String downloadURL =
          await storage.ref('items').child(imageName).getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      return 'there has been an error';
    }
  }
}
