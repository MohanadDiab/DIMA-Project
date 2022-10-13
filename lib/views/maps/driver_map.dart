import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:location/location.dart';

class DriverMap extends StatefulWidget {
  const DriverMap({Key? key}) : super(key: key);

  @override
  State<DriverMap> createState() => DriverMapState();
}

class DriverMapState extends State<DriverMap> {
  final googleApiKey = 'AIzaSyAktuBhmVOtCZN12HIOe3mSkJMit0Oqs04';
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(26.8206, 30.8025));
  final Completer<GoogleMapController> _controller = Completer();
  bool deliveryIsVisible = false;
  late LatLng destination;
  late LocationData myLocation;

  @override
  void initState() {
    var location = Location();
    location.getLocation().then((value) => myLocation = value);
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future getMyCurrentLocation() async {
    var location = Location();
    myLocation = await location.getLocation();
    var sourceLocation = LatLng(myLocation.latitude!, myLocation.longitude!);

    return Marker(
      markerId: const MarkerId('Current position'),
      position: sourceLocation,
      infoWindow: const InfoWindow(title: 'Current location'),
    );
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;
  final double _zoom = 15;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var myMarker = await getMyCurrentLocation();
            _markers.add(myMarker);
            GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(myMarker.position.latitude, myMarker.position.longitude),
                _zoom));
            setState(() {});
          },
          child: const Icon(
            Icons.my_location_outlined,
          )),
      appBar: AppBar(
        title: GenericText(text: "Orders", color: color2),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            polylines: {
              Polyline(
                polylineId: const PolylineId('Delivery route'),
                points: polyLineCoordinates,
                color: color3,
                width: 5,
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: _markers,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
          ),
          Visibility(
            visible: deliveryIsVisible,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(left: 100, right: 100),
                    child: GenericButton(
                        primaryColor: color3,
                        pressColor: color2,
                        text: 'Start delivery',
                        onPressed: () async {
                          var myLocation = await Location().getLocation();
                          LatLng sourceLocation = LatLng(
                              myLocation.latitude!, myLocation.longitude!);
                          getPolyPoints(
                              origin: sourceLocation, destination: destination);
                          deliveryIsVisible = false;
                        },
                        textColor: color2),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: CloudService().getDriverProfile(userId: userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return UserAccountsDrawerHeader(
                      accountName: Text(snapshot.data['name']),
                      accountEmail: Text(snapshot.data['city']),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data['picture_url']),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
          const ListTile(
            title: Text("Deliveries"),
            leading: Icon(Icons.delivery_dining),
          ),
          const Divider(),
          StreamBuilder(
            stream: CloudService().getDriverRequests(userId: userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  final docs = snapshot.data.docs!;
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 10,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            _goToCustomer(
                              name: docs[index].data()['name'],
                              item: docs[index].data()['item'],
                              notes: docs[index].data()['notes'],
                              lat: docs[index].data()['location'].latitude,
                              long: docs[index].data()['location'].longitude,
                            );
                            Navigator.of(context).pop();
                          },
                          title: Text(docs[index].data()['name']),
                          trailing: const Icon(Icons.my_location_outlined),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  List<LatLng> polyLineCoordinates = [];

  void getPolyPoints({
    required LatLng origin,
    required LatLng destination,
  }) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      });
      setState(() {});
    }
  }

  Future<void> _goToCustomer({
    required String name,
    required String item,
    required String notes,
    required double lat,
    required double long,
  }) async {
    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), _zoom));

    setState(() {
      _markers.add(
        Marker(
          onTap: () {
            deliveryIsVisible = true;
            destination = LatLng(lat, long);
            setState(() {});
          },
          markerId: MarkerId(name),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(title: name, snippet: "Item: $item"),
        ),
      );
    });
  }
}
