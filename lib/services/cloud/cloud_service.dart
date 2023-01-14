import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class CloudService {
  // Instantiating
  final driverCollection = FirebaseFirestore.instance.collection('drivers');
  final sellerCollection = FirebaseFirestore.instance.collection('sellers');
  final buyerCollection = FirebaseFirestore.instance.collection('buyers');

  // Create

  Future<void> createSellerSupportRequest({
    required String userId,
    required String email,
    required String subject,
  }) async {
    await sellerCollection.doc(userId).set(
      {'support_email': email, 'support_body': subject},
      SetOptions(merge: true),
    );
  }

  Future<void> uploadSellerImage({
    required String userId,
    required String pictureUrl,
  }) async {
    await sellerCollection.doc(userId).set(
      {
        'picture_url': pictureUrl,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> uploadDriverImage({
    required String userId,
    required String pictureUrl,
  }) async {
    await driverCollection.doc(userId).set(
      {
        'picture_url': pictureUrl,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateSellerProfile({
    required String userId,
    required String name,
    required String number,
    required String city,
  }) async {
    await sellerCollection.doc(userId).set(
      {'name': name, 'number': number, 'city': city},
      SetOptions(merge: true),
    );
  }

  Future<void> createSellerProfile({
    required String userId,
    required String name,
    required String city,
    required int number,
  }) async {
    await sellerCollection.doc(userId).set(
      {
        'name': name,
        'city': city,
        'is_assigned': false,
        'is_published': false,
        'number': number,
        'user_id': userId,
      },
    );
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

  Future<void> createUpdateRequest({
    required String userId,
    required String email,
    required String name,
    required String item,
    required double price,
    required int number,
    required String notes,
    required String address,
    required double lat,
    required double long,
    required String pictureUrl,
  }) async {
    if (notes.isEmpty) {
      notes = 'None';
    }
    await sellerCollection
        .doc(userId)
        .collection('seller_requests')
        .doc(name)
        .set({
      'name': name,
      'email': email,
      'number': number,
      'price': price,
      'item': item,
      'notes': notes,
      'picture_url': pictureUrl,
      'location': GeoPoint(lat, long),
      'address': address,
    });
  }

  // Read

  Future<String> getDriverIDFromName({required String name}) async {
    final driverInfo =
        await driverCollection.where('name', isEqualTo: name).get();
    final driverId = driverInfo.docs[0].data()['user_id'];
    return driverId;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getAssignedSeller(
      {required String userId}) {
    return driverCollection.doc(userId).get().asStream();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSellerLocation(
      {required String userId}) {
    return sellerCollection.doc(userId).get().asStream();
  }

  Future<bool> getIfDriverCollected({required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    final is_Collected = driver.data()!['is_Collected'];
    if (is_Collected == true) {
      return true;
    } else {
      return false;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDriverAsStream(
      {required String userId}) {
    return driverCollection.doc(userId).get().asStream();
  }

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
    //await Future.delayed(const Duration(seconds: 3));
    if (driver.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sellerIsPublished({required String userId}) async {
    final seller = await sellerCollection.doc(userId).get();
    final isPublished = seller.data()!['is_published'];
    if (isPublished) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> sellerAssignedDriver(
      {required String userId}) async {
    final seller = await sellerCollection.doc(userId).get();
    final driverId = seller.data()!['assigned_driver'];
    final driverInfo =
        await driverCollection.where('user_id', isEqualTo: driverId).get();
    return driverInfo.docs[0].data();
  }

  Future<bool> sellerIsAssigned({required String userId}) async {
    final seller = await sellerCollection.doc(userId).get();
    final isAssigned = seller.data()!['is_assigned'];
    if (isAssigned) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> setRoute(
      {required String userId, required List<GeoPoint> route}) async {
    await driverCollection
        .doc(userId)
        .set({'route': route}, SetOptions(merge: true));
  }

  Future<List<GeoPoint>> getRoute({required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data()!['route'];
  }

  Future<void> setCollected({required String userId}) async {
    await driverCollection.doc(userId).set(
      {'is_Collected': true},
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getDriverProfile(
      {required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data();
  }

  Future<Map<String, dynamic>?> getDriverSeller(
      {required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    final sellerId = driver.data()!['assigned_seller'];
    final seller = await sellerCollection.doc(sellerId).get();
    return seller.data();
  }

  Future<Map<String, dynamic>?> getSellerProfile(
      {required String userId}) async {
    final seller = await sellerCollection.doc(userId).get();
    return seller.data();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriverRequests(
      {required String userId}) {
    return driverCollection
        .doc(userId)
        .collection('driver_requests')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSellerRequests(
      {required String userId}) {
    return sellerCollection
        .doc(userId)
        .collection('seller_requests')
        .snapshots();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getSellerRequestsFuture({required String userId}) async {
    final requests =
        await sellerCollection.doc(userId).collection('seller_requests').get();
    return requests.docs;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSellerRequestsArchived(
      {required String userId}) {
    return sellerCollection
        .doc(userId)
        .collection('seller_requests_archived')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriverRequestsArchived(
      {required String userId}) {
    return driverCollection
        .doc(userId)
        .collection('seller_requests_archived')
        .snapshots();
  }

  Future<bool> isRequestActive({required userId}) async {
    final doc = await sellerCollection.doc(userId).get();
    return doc.data()!['request_active'];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllActiveRequests() {
    return sellerCollection
        .where('is_assigned', isEqualTo: false)
        .where('is_published', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getClosestRequests(
      {required String city}) {
    return sellerCollection
        .where('is_assigned', isEqualTo: false)
        .where('is_published', isEqualTo: true)
        .where('city', isEqualTo: city)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getSellerRequestInfo(
      {required String userId, required String name}) async {
    final request = await sellerCollection
        .doc(userId)
        .collection('seller_requests')
        .doc(name)
        .get();
    return request.data();
  }

  Future<void> updateNotificationToken({
    required String userId,
    required String? token,
    required bool? isDriver,
  }) async {
    switch (isDriver) {
      case true:
        await driverCollection.doc(userId).set(
          {'token': token},
          SetOptions(merge: true),
        );
        break;
      case false:
        await sellerCollection.doc(userId).set(
          {'token': token},
          SetOptions(merge: true),
        );
        break;
    }
  }

  //update

  Future<void> publishSeller({required userId}) async {
    return sellerCollection.doc(userId).set(
      {'is_published': true},
      SetOptions(merge: true),
    );
  }

  Future<void> assignToDriver({
    required String userId,
    required String sellerName,
  }) async {
    // get seller ID, driver ID
    final request =
        await sellerCollection.where('name', isEqualTo: sellerName).get();
    final sellerId = request.docs[0].id;
    final driver = await driverCollection.doc(userId).get();
    final driverID = driver.data()!['user_id'];

    // Set seller to is_assigned and the assigned_driver is set ot the driver's name
    sellerCollection.doc(sellerId).set(
      {
        'is_assigned': true,
        'assigned_driver': driverID,
        'is_Collected': false,
      },
      SetOptions(merge: true),
    );
    driverCollection.doc(userId).set(
      {
        'assigned_seller': sellerId,
        'is_Collected': false,
      },
      SetOptions(merge: true),
    );

    // gets the seller requests and adds them to the driver
    final sellerRequest = await sellerCollection
        .doc(sellerId)
        .collection('seller_requests')
        .get();
    final addedRequest = sellerRequest.docs;
    for (var element in addedRequest) {
      var id = element.id;
      await driverCollection
          .doc(userId)
          .collection('driver_requests')
          .doc(id)
          .set(element.data());
    }
  }

  // Delete

  Future<void> deleteSellerRequest(
      {required String userId, required String name}) async {
    await sellerCollection
        .doc(userId)
        .collection('seller_requests')
        .doc(name)
        .delete();
  }
}
