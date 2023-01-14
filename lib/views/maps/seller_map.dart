import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../main.dart';

class SellerMap extends StatefulWidget {
  const SellerMap({Key? key}) : super(key: key);
  @override
  State<SellerMap> createState() => SellerMapState();
}

class SellerMapState extends State<SellerMap> {
  MapboxMapController? mapController;
  GeoPoint? sellerLocation;
  bool collectedIsVisible = false;
  late LatLng destination;
  LocationData? currentLocation;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  StreamSubscription<LocationData>? locationSubscription;
  var location = Location();
  String? assigned_driver;
  SymbolOptions _getSymbolOptions(LatLng geometry, String text, String image) {
    return SymbolOptions(
      geometry: geometry,
      textField: text,
      textOffset: Offset(0, 0.8),
      iconImage: image,
    );
  }

  Future<void> removeAll(MapboxMapController _mapController) async {
    try {
      _mapController.symbols.forEach((symbol) {
        _mapController.removeSymbol(symbol);
      });
    } catch (exception) {
      print('no symbol');
    }
    try {
      _mapController.lines.forEach((line) {
        _mapController.removeLine(line);
      });
    } catch (exception) {
      print('no line');
    }
  }

  Future<void> refreshMap() async {
    await removeAll(mapController!);
    locationSubscription?.cancel();
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 5000, distanceFilter: 5);
    CloudService().getDriverRequests(userId: userId).listen((event) async {
      if (event.size > 0) {
        if (await CloudService().getIfDriverCollected(userId: userId)) {
          //to costumers
          collectedIsVisible = false;
          List<LatLng> destinations = [];
          mapController!.symbols.forEach((symbol) {
            if (symbol.options.iconImage == 'mountain-15') {
              mapController!.removeSymbol(symbol);
            }
          });
          for (QueryDocumentSnapshot<Map<String, dynamic>> deliveringItem
              in event.docs) {
            GeoPoint _location = deliveringItem.data()['location'];
            destinations.add(LatLng(_location.latitude, _location.longitude));
            mapController?.addSymbol(_getSymbolOptions(
                LatLng(_location.latitude, _location.longitude),
                '',
                'mountain-15'));
          }
          locationSubscription = location.onLocationChanged
              .listen((LocationData _currentLocation) {
            currentLocation = _currentLocation;
            LatLng _LatLngCurrentLocation =
                LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
            mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _LatLngCurrentLocation, zoom: 12),
            ));
            mapController!.symbols.forEach((symbol) {
              if (symbol.options.iconImage == 'bicycle-15') {
                mapController!.removeSymbol(symbol);
              }
            });
            mapController?.addSymbol(
                _getSymbolOptions(_LatLngCurrentLocation, '', 'bicycle-15'));
          });
        } else {
          //to sellers
          collectedIsVisible = true;
          CloudService()
              .getAssignedSeller(userId: userId)
              .listen((event) async {
            final assignedSeller = event.data()!['assigned_seller'];
            CloudService()
                .getSellerLocation(userId: assignedSeller)
                .listen((event) async {
              final sellerLocation = event.data()!['location'];
              locationSubscription = location.onLocationChanged
                  .listen((LocationData currentLocation) {
                LatLng _currentLocation = LatLng(
                    currentLocation.latitude!, currentLocation.longitude!);
                mapController!.symbols.forEach((symbol) {
                  if (symbol.options.iconImage == 'bicycle-15') {
                    mapController!.removeSymbol(symbol);
                  }
                });
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: _currentLocation, zoom: 12),
                ));
                mapController?.addSymbol(
                    _getSymbolOptions(_currentLocation, '', 'bicycle-15'));
              });
              mapController!.addSymbol(_getSymbolOptions(
                  LatLng(sellerLocation!.latitude, sellerLocation!.longitude),
                  'seller',
                  'restaurant-15'));
            });
          });
        }
      }
    });
  }

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    refreshMap();
    setState(() {});
  }

  _onStyleLoadedCallback() {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text("Style loaded :)"),
    //   backgroundColor: Theme.of(context).primaryColor,
    //   duration: Duration(seconds: 1),
    // ));
  }

  @override
  void initState() {
    super.initState();
  }

  Future getMyCurrentLocation() async {
    mapController!.symbols.forEach((s) => print(s.options.iconImage));
    final myLocation = await Location().getLocation();
    return LatLng(myLocation.latitude!, myLocation.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            LatLng currentLocation = await getMyCurrentLocation();
            mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: currentLocation, zoom: 12.5),
            ));
          },
          child: const Icon(
            Icons.my_location_outlined,
          )),
      appBar: AppBar(
        title: genericText(text: "Orders", color: color2),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: Stack(
        children: <Widget>[
          MapboxMap(
            styleString: MapboxStyles.LIGHT,
            accessToken: HomePage.ACCESS_TOKEN,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
                target: LatLng(45.46785215366453, 9.182147988302752),
                zoom: 12.5),
            onStyleLoadedCallback: _onStyleLoadedCallback,
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
            stream: CloudService().getSellerRequests(userId: userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final docs = snapshot.data.docs!;
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

  Future<void> _goToCustomer({
    required String name,
    required String item,
    required String notes,
    required double lat,
    required double long,
  }) async {
    setState(() {
      // _markers.add(
      //   Marker(
      //     onTap: () {
      //       deliveryIsVisible = true;
      //       setState(() {});
      //     },
      //     markerId: MarkerId(name),
      //     infoWindow: InfoWindow(title: name, snippet: "Item: $item"),
      //   ),
      // );
    });
  }
}
