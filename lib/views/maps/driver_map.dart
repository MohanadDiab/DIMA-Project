import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMap extends StatefulWidget {
  const DriverMap({Key? key}) : super(key: key);

  @override
  State<DriverMap> createState() => DriverMapState();
}

class DriverMapState extends State<DriverMap> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30, 30),
    zoom: 1,
  );
  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      initialCameraPosition: _kGooglePlex,
    );
  }
}
