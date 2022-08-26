import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {
  // Instantiating
  final driverCollection = FirebaseFirestore.instance.collection('drivers');
  final sellerCollection = FirebaseFirestore.instance.collection('sellers');
  final buyerCollection = FirebaseFirestore.instance.collection('buyers');

  // Create

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

  Future<void> createBuyerProfile({
    required String name,
    required String email,
  }) async {
    await buyerCollection.doc(email).set(
      {
        'name': name,
        'email': email,
        'is_buyer': true,
        'is_delivered': false,
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
      'is_active': false,
    });
  }

  // Read
  Future<Object> sellerRequestsIsEmpty({required String userId}) async {
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

  Future<bool> isRequestActive({required userId}) async {
    final doc = await sellerCollection.doc(userId).get();
    return doc.data()!['request_active'];
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getAllRequests() async {
    final sellerRequests = await sellerCollection.get();

    final sellerRequestsDocs = sellerRequests.docs;
    return sellerRequestsDocs;
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

  //update

  Future<void> assignToDriver({
    required String userId,
    required String sellerName,
  }) async {
    final request =
        await sellerCollection.where('name', isEqualTo: sellerName).get();
    final sellerId = request.docs[0].id;
    final sellerRequest = await sellerCollection
        .doc(sellerId)
        .collection('seller_requests')
        .get();
    final addedRequest = sellerRequest.docs;
    for (var element in addedRequest) {
      var id = element.id;
      await sellerCollection
          .doc(sellerId)
          .collection('seller_requests')
          .doc(id)
          .set(
        {'is_active': true, 'is_delivered': false},
        SetOptions(merge: true),
      );

      await driverCollection
          .doc(userId)
          .collection('driver_requests')
          .doc(id)
          .set(element.data());
      await driverCollection
          .doc(userId)
          .collection('driver_requests')
          .doc(id)
          .set(
        {'seller_id': sellerId, 'is_delivered': false},
        SetOptions(merge: true),
      );
    }
  }

  Future<void> itemDelivered({
    required String userId,
    required String customer,
  }) async {
    final doc = await driverCollection
        .doc(userId)
        .collection('driver_requests')
        .doc(customer)
        .get();
    final sellerId = doc.data()!['seller_id'];

    await driverCollection
        .doc(userId)
        .collection('driver_requests')
        .doc(customer)
        .set(
      {'is_delivered': true},
      SetOptions(merge: true),
    );
    await sellerCollection
        .doc(sellerId)
        .collection('seller_requests')
        .doc(customer)
        .set(
      {'is_delivered': true},
      SetOptions(merge: true),
    );
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
