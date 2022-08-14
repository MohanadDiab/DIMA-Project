import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testapp/services/cloud/drivers.dart';

class DriverMap extends StatefulWidget {
  const DriverMap({Key? key}) : super(key: key);

  @override
  State<DriverMap> createState() => DriverMapState();
}

class DriverMapState extends State<DriverMap> {
  final CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(26.8206, 30.8025));
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;
  final double _zoom = 15;
  final Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: _markers,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
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
          const UserAccountsDrawerHeader(
            accountName: Text("xyz"),
            accountEmail: Text("xyz@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("xyz"),
            ),
            otherAccountsPictures: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("abc"),
              )
            ],
          ),
          const ListTile(
            title: Text("Deliveries"),
            leading: Icon(Icons.delivery_dining),
          ),
          const Divider(),
          FutureBuilder(
            future: DriverCloud().getDriverRequests(userId: userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 10,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            _goToCustomer(
                              name: snapshot.data[index].data()['name'],
                              item: snapshot.data[index].data()['item'],
                              notes: snapshot.data[index].data()['notes'],
                              lat: snapshot.data[index]
                                  .data()['location']
                                  .latitude,
                              long: snapshot.data[index]
                                  .data()['location']
                                  .longitude,
                            );
                            Navigator.of(context).pop();
                          },
                          title: Text(snapshot.data[index].data()['name']),
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
          )
        ],
      ),
    );
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
          markerId: MarkerId(name),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(title: name, snippet: "Item: $item"),
        ),
      );
    });
  }
}
