import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

class RequestsMap extends StatefulWidget {
  final String userId;
  final String name;
  final String address;
  const RequestsMap({
    Key? key,
    required this.userId,
    required this.name,
    required this.address,
  }) : super(key: key);

  @override
  State<RequestsMap> createState() => RequestsMapState();
}

class RequestsMapState extends State<RequestsMap> {
  final Set<Marker> _markers = {};
  final double _zoom = 11.5;
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(26.8206, 30.8025));
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    _addCustomers(userId: widget.userId);
    _centerCamera(address: widget.address);
    super.initState();
  }

  Future<void> _centerCamera({required String address}) async {
    var locations = await locationFromAddress(widget.address);
    final long = locations.last.longitude;
    final lat = locations.last.latitude;
    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));
    setState(() {});
  }

  Future<void> _addCustomers({
    required String userId,
  }) async {
    final customerRequests =
        await CloudService().getSellerRequestsFuture(userId: userId);

    for (var k in customerRequests) {
      final lat = k.data()['location'].latitude;
      final long = k.data()['location'].longitude;
      final name = k.data()['name'];
      final item = k.data()['item'];

      _markers.add(
        Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(title: name, snippet: "Item: $item"),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: _markers,
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: _initialPosition,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      buildingsEnabled: false,
    );
  }
}
