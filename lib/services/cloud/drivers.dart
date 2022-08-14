import 'package:cloud_firestore/cloud_firestore.dart';

class DriverCloud {
  final requests = FirebaseFirestore.instance.collection('drivers');
  final requestsS = FirebaseFirestore.instance.collection('sellers');

  Future<Map<String, dynamic>?> getDriverProfile(
      {required String userId}) async {
    final driver = await requests.doc(userId).get();
    return driver.data();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDriverRequests(
      {required String userId}) async {
    final driverRequests =
        await requests.doc(userId).collection('driver_requests').get();
    final driverRequestsDocs = driverRequests.docs;
    return driverRequestsDocs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getSellerRequests(
      {required String userId}) async {
    final driverRequests =
        await requestsS.doc(userId).collection('seller_requests').get();
    final driverRequestsDocs = driverRequests.docs;
    return driverRequestsDocs;
  }

  Future<void> createDriverProfile({
    required String userId,
    required String name,
    required String city,
    required int number,
  }) async {
    await requests.doc(userId).set(
      {
        'name': name,
        'city': city,
        'number': number,
        'user_id': userId,
      },
    );
  }
}
