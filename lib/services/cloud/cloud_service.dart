import 'package:cloud_firestore/cloud_firestore.dart';

class DriverCloud {
  final driverCollection = FirebaseFirestore.instance.collection('drivers');
  final sellerCollection = FirebaseFirestore.instance.collection('sellers');

  Future<bool> sellerRequestsIsEmpty({required String userId}) async {
    final sellerRequestsCollection =
        await sellerCollection.doc(userId).collection('seller_requests').get();
    final isEmpty = sellerRequestsCollection.docs;
    if (isEmpty.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isDriver({required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    if (driver.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDriverProfile(
      {required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data();
  }

  Future<Map<String, dynamic>?> getSellerProfile(
      {required String userId}) async {
    final seller = await sellerCollection.doc(userId).get();
    return seller.data();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDriverRequests(
      {required String userId}) async {
    final driverRequests =
        await driverCollection.doc(userId).collection('driver_requests').get();
    final driverRequestsDocs = driverRequests.docs;
    return driverRequestsDocs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getSellerRequests(
      {required String userId}) async {
    final sellerRequests =
        await sellerCollection.doc(userId).collection('seller_requests').get();
    final sellerRequestsDocs = sellerRequests.docs;
    return sellerRequestsDocs;
  }

  Future<void> createDriverProfile({
    required String userId,
    required String name,
    required String city,
    required int number,
  }) async {
    await driverCollection.doc(userId).set(
      {
        'name': name,
        'city': city,
        'number': number,
        'user_id': userId,
      },
    );
  }

  Future<void> createRequest({
    required String userId,
    required String name,
    required String item,
    required int number,
    required String notes,
    required double lat,
    required double long,
    required String pictureUrl,
  }) async {
    await sellerCollection
        .doc(userId)
        .collection('seller_requests')
        .doc(name)
        .set({
      'name': name,
      'number': number,
      'item': item,
      'notes': notes,
      'picture_url': pictureUrl,
    });
  }
}
