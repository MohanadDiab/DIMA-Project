import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CloudService {
  // Instantiating
  final driverCollection = FirebaseFirestore.instance.collection('drivers');
  final sellerCollection = FirebaseFirestore.instance.collection('sellers');
  final requestCollection = FirebaseFirestore.instance.collection('requests');

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

  Future<void> addDeliveredImage({
    required String userId,
    required String itemId,
    required String pictureUrl,
  }) async {
    await requestCollection.doc(itemId).set(
      {
        'delivered_picture_url': pictureUrl,
        'is_delivered': true,
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
    required String address,
    required double lat,
    required double lng,
  }) async {
    await sellerCollection.doc(userId).set(
      {
        'name': name,
        'city': city,
        'is_assigned': false,
        'is_published': false,
        'number': number,
        'user_id': userId,
        'address': address,
        'location': GeoPoint(lat, lng),
        'picture_utl':
            'https://firebasestorage.googleapis.com/v0/b/my-dima-test-app.appspot.com/o/items%2Fuser.png?alt=media&token=3f98705c-a749-4a3a-869c-074951369f50'
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
        'is_assigned': false,
        'picture_utl':
            'https://firebasestorage.googleapis.com/v0/b/my-dima-test-app.appspot.com/o/items%2Fuser.png?alt=media&token=3f98705c-a749-4a3a-869c-074951369f50'
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
    await requestCollection.doc().set({
      'assigned_seller': userId,
      'name': name,
      'email': email,
      'number': number,
      'price': price,
      'item': item,
      'notes': notes,
      'picture_url': pictureUrl,
      'location': GeoPoint(lat, long),
      'address': address,
      'is_delivered': false,
      'is_assigned': false,
    }, SetOptions(merge: true));
    await sellerCollection.doc(userId).set(
        {'is_published': false, 'is_assigned': false}, SetOptions(merge: true));
  }

  Future<String> getAssignedSeller({required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data()!['assigned_seller'];
  }

  Future<GeoPoint> getSellerLocation({required String userId}) async {
    final seller = await sellerCollection.doc(userId).get();
    return seller.data()!['location'];
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDriverAsSnapshot(
      {required String userId}) {
    return driverCollection.doc(userId).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSellerAsSnapshot(
      {required String userId}) {
    return sellerCollection.doc(userId).snapshots();
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

  Future<void> setDriverLocation(
      {required String userId, required GeoPoint location}) async {
    await driverCollection
        .doc(userId)
        .set({'location': location}, SetOptions(merge: true));
  }

  Future<List<GeoPoint>> getRoute({required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data()!['route'];
  }

  Future<void> setCollected({required String userId}) async {
    await driverCollection.doc(userId).set(
      {'is_collected': true},
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getDriverProfile(
      {required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data();
  }

  Future<Map<String, dynamic>?> getDriverSellerInfo(
      {required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    final sellerId = driver.data()!['assigned_seller'];
    final seller = await sellerCollection.doc(sellerId).get();
    return seller.data();
  }

  Future<Map<String, dynamic>?> getDriverInfo({required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data();
  }

  Future<String> getDriverSellerUserId({required String userId}) async {
    final driver = await driverCollection.doc(userId).get();
    return driver.data()!['assigned_seller'];
  }

  Future<Map<String, dynamic>?> getSellerProfile(
      {required String userId}) async {
    final seller = await sellerCollection.doc(userId).get();
    return seller.data();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAliveDriverRequests(
      {required String userId}) {
    return requestCollection
        .where('assigned_driver', isEqualTo: userId)
        .where('is_delivered', isEqualTo: false)
        .where('is_assigned', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSellerRequests(
      {required String userId}) {
    return requestCollection
        .where('assigned_seller', isEqualTo: userId)
        .where('is_delivered', isEqualTo: false)
        .snapshots();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getSellerRequestsFuture({required String userId}) async {
    final requests = await requestCollection
        .where('assigned_seller', isEqualTo: userId)
        .where('is_assigned', isEqualTo: false)
        .get();
    return requests.docs;
  }

  Future<void> setRequestStatus(
      {required String userId,
      required String docId,
      required List<GeoPoint> route,
      required double remainedDistance,
      required double remainedTime}) async {
    if (!(await requestCollection.doc(docId).snapshots().isEmpty)) {
      print(requestCollection.doc(docId).snapshots());
      await requestCollection.doc(docId).set({
        'route': route,
        'remainedDistance': remainedDistance,
        'remainedTime': remainedTime
      }, SetOptions(merge: true));
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSellerRequestsArchived(
      {required String userId}) {
    return requestCollection
        .where('assigned_seller', isEqualTo: userId)
        .where('is_delivered', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriverRequestsArchived(
      {required String userId}) {
    return requestCollection
        .where('assigned_driver', isEqualTo: userId)
        .where('is_delivered', isEqualTo: true)
        .snapshots();
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
      {required String userId, required String itemId}) async {
    final request = await requestCollection.doc(itemId).get();
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

  Future<void> setItemRate({required itemId, required double rate}) async {
    return requestCollection.doc(itemId).set(
      {'rate': rate},
      SetOptions(merge: true),
    );
  }

//todo
  Future<void> assignToDriver({
    required String driverUserId,
    required String sellerUserId,
  }) async {
    // get seller ID, driver ID
    // Set seller to is_assigned and the assigned_driver is set ot the driver's name
    sellerCollection.doc(sellerUserId).set(
      {
        'is_assigned': true,
        'is_published': true,
        'assigned_driver': driverUserId,
      },
      SetOptions(merge: true),
    );
    driverCollection.doc(driverUserId).set(
      {
        'assigned_seller': sellerUserId,
        'is_assigned': true,
        'is_collected': false
      },
      SetOptions(merge: true),
    );
    var requests = await requestCollection
        .where('assigned_seller', isEqualTo: sellerUserId)
        .where('is_assigned', isEqualTo: false)
        .where('is_delivered', isEqualTo: false)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> item in requests.docs) {
      String id = item.id;
      await requestCollection.doc(id).set(
        {
          'assigned_driver': driverUserId,
          'assigned_seller': sellerUserId,
          'is_assigned': true,
          'is_delivered': false
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> storeReceivedMsg(
      {required String userId,
      required String title,
      required String msg}) async {
    await driverCollection
        .doc(userId)
        .collection('msg')
        .add({'title': title, 'msg': msg});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDriverReceivedMsg(
      {required String userId}) {
    return driverCollection.doc(userId).collection('msg').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSellerReceivedMsg(
      {required String userId}) {
    return sellerCollection.doc(userId).collection('msg').snapshots();
  }

  // Delete

  Future<void> deleteSellerRequest(
      {required String userId, required String itemId}) async {
    await requestCollection.doc(itemId).delete();
  }
}
