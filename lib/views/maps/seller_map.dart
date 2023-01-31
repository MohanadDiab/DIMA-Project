import 'dart:async';
//import 'dart:ffi';
import 'dart:ui';
import 'dart:convert' as convert;
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:location/location.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import '../../main.dart';
import '../driver_pages/driver_camera.dart';

class SellerMap extends StatefulWidget {
  const SellerMap({Key? key}) : super(key: key);
  @override
  State<SellerMap> createState() => SellerMapState();
}

class SellerMapState extends State<SellerMap>
    with AutomaticKeepAliveClientMixin {
  MapboxMapController? mapController;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  SymbolOptions _getSymbolOptions(LatLng geometry, String text, String image) {
    return SymbolOptions(
        geometry: geometry, textOffset: Offset(0, 0.8), iconImage: image);
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

  Map<String, dynamic> currentSituation = {
    'sellerLocation': null,
    'driverLocation': null,
    'assignedDriver': '',
    'collectingRoute': [],
    'currentTask': [],
    'isAssigned': false,
    'isCollected': false,
  };

  Future<void> updateMap() async {
    if (currentSituation['sellerLocation'] == null ||
        currentSituation['driverLocation'] == null ||
        currentSituation['assignedDriver'] == '' ||
        currentSituation['collectingRoute'] == [] ||
        currentSituation['isAssigned'] == false ||
        currentSituation['currentTask'].isEmpty()) {
      print('initialization unfinished or no task is undergoing.');
    } else {
      //what task should we do
      //not assigned
      if (currentSituation['isAssigned'] != true) {
        print('notask');
        await removeAll(mapController!);
      } else {
        await removeAll(mapController!);
        //add driver location
        LatLng driverLocation = LatLng(
            currentSituation['driverLocation'].latitude,
            currentSituation['driverLocation'].longitude);
        await mapController
            ?.addSymbol(_getSymbolOptions(driverLocation, '', 'bicycle-15'));
        //add seller location
        LatLng sellerLocation = LatLng(
            currentSituation['sellerLocation'].latitude,
            currentSituation['sellerLocation'].longitude);
        await mapController?.addSymbol(
            _getSymbolOptions(sellerLocation, 'seller', 'restaurant-15'));
        //assgined but not collected, show collecting route
        if (currentSituation['isCollected'] != true) {
          print('collecting');
          print(currentSituation['isCollected']);
          //add collecting route
          var geometry = <LatLng>[];
          List route = currentSituation['collectingRoute'];
          if (route.isNotEmpty) {
            for (GeoPoint point in route) {
              geometry.add(LatLng(point.latitude, point.longitude));
            }
            LineOptions computedLine = LineOptions(
                geometry: geometry,
                lineColor: "#ff0000",
                lineWidth: 6,
                lineOpacity: 0.5,
                draggable: false);
            await mapController!.addLine(computedLine);
          }
        }
        //delivering
        else {
          print('delivering');
          for (QueryDocumentSnapshot<Map<String, dynamic>> deliveringItem
              in currentSituation['currentTask']) {
            var geometry = <LatLng>[];
            Map<String, dynamic> symbolData = {};
            symbolData['name'] = deliveringItem.data()['name'];
            symbolData['remainedDistance'] =
                deliveringItem.data()['remainedDistance'] ?? '';
            symbolData['remainedTime'] =
                deliveringItem.data()['remainedTime'] ?? '';
            List route = deliveringItem.data()['route'];
            if (route.isNotEmpty) {
              await mapController?.addSymbol(
                  _getSymbolOptions(
                      LatLng(route.last.latitude, route.last.longitude),
                      '',
                      'mountain-15'),
                  symbolData);
              for (GeoPoint point in route) {
                geometry.add(LatLng(point.latitude, point.longitude));
              }
              LineOptions computedLine = LineOptions(
                  geometry: geometry,
                  lineColor: "#ff0000",
                  lineWidth: 3.0,
                  lineOpacity: 0.5,
                  draggable: false);
              await mapController!.addLine(computedLine);
            }
          }
        }
      }
      setState(() {});
    }
  }

  _showSnackBar(String info) {
    final snackBar = SnackBar(
        content: Text(info,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onSymbolTapped(Symbol symbol) {
    print(symbol.data!["name"]);
    _showSnackBar(
        'Name:${symbol.data!["name"]},Remained Time: ${(symbol.data!["remainedTime"] / 60).toStringAsFixed(1)} min');
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      driverSnapshotSubscription;
  void changeDriverUserId({required String userId}) {
    driverSnapshotSubscription?.cancel();
    driverSnapshotSubscription =
        CloudService().getDriverAsSnapshot(userId: userId).listen((event) {
      final driverProfile = event.data();
      currentSituation['collectingRoute'] = driverProfile!['route'];

      if (currentSituation['isCollected'] != driverProfile['is_collected']) {
        currentSituation['isCollected'] = driverProfile['is_collected'];
      }
      print(currentSituation['isCollected']);
      currentSituation['driverLocation'] = driverProfile['location'];
      //
      updateMap();
    });
  }

  _onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);

    CloudService().getSellerAsSnapshot(userId: userId).listen((event) {
      final sellerProfile = event.data();
      final sellerLocation = sellerProfile!['location'] ?? 0;
      final assignedDriver = sellerProfile['assigned_driver'] ?? '';
      final isAssigned = sellerProfile['is_assigned'] ?? false;
      if (sellerLocation != currentSituation['sellerLocation']) {
        currentSituation['sellerLocation'] = sellerLocation;
      }
      if (assignedDriver != currentSituation['assignedDriver']) {
        currentSituation['assignedDriver'] = assignedDriver;
        changeDriverUserId(userId: assignedDriver);
      }
      if (isAssigned != currentSituation['isAssigned']) {
        currentSituation['isAssigned'] = isAssigned;
      }
      //
      updateMap();
    });
    CloudService()
        .getSellerRequestsAssigned(userId: userId)
        .listen((event) async {
      List requests = event.docs;
      if (requests != currentSituation['currentTask']) {
        currentSituation['currentTask'] = requests;
        //
        updateMap();
      }
    });
  }

  _onStyleLoadedCallback() {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text("Style loaded :)"),
    //   backgroundColor: Theme.of(context).primaryColor,
    //   duration: Duration(seconds: 1),
    // ));
  }

  CameraDescription? firstCamera;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    super.build(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
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
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              }),
          Visibility(
            visible: (!(currentSituation['currentTask'].length == 0) &&
                currentSituation['isCollected']),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    height: 230,
                    child: StreamBuilder(
                        stream: CloudService()
                            .getSellerRequestsAssigned(userId: userId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                final docs = snapshot.data.docs!;
                                return ScrollSnapList(
                                  itemBuilder: (context, index) {
                                    var product = docs[index].data();
                                    final size = MediaQuery.of(context).size;
                                    final width = size.width;
                                    final height = size.height;
                                    return SizedBox(
                                      width: width * 0.8,
                                      height: 230,
                                      child: Card(
                                        elevation: 12,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Column(
                                            children: [
                                              Image.network(
                                                product['picture_url'],
                                                fit: BoxFit.cover,
                                                width: width * 0.8,
                                                height: 180,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                product['name'],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: docs.length,
                                  itemSize: width * 0.8,
                                  onItemFocus: (index) {},
                                  dynamicItemSize: true,
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            default:
                              return const CircularProgressIndicator();
                          }
                        }),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Visibility(
            visible: (!(currentSituation['currentTask'].length == 0) &&
                !currentSituation['isCollected']),
            child: Center(
                child: Column(
              children: [
                SizedBox(
                  height: height * 0.55,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.1,
                    child: Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Retrieve Items',
                            textScaleFactor: 2,
                          )
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  final _dialog = RatingDialog(
    initialRating: 1.0,
    // your app's name?
    title: Text(
      'How about the service?',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    message: Text(
      'Tap a star to set your rating. Add more description here if you want.',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ),
    // your app's logo?
    image: const FlutterLogo(size: 100),
    submitButtonText: 'Submit',
    commentHint: 'Write here if you have more to say!',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

      // TODO: add your own logic
      if (response.rating < 3.0) {
        print(1);
      } else {
        print(2);
      }
    },
  );

  Widget _drawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: CloudService().getSellerProfile(userId: userId),
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
            stream: CloudService().getSellerRequestsAssigned(userId: userId),
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
                        String remainedDistance =
                            docs[index].data()["remainedDistance"] == null
                                ? '...'
                                : (docs[index].data()["remainedDistance"] /
                                        1000)
                                    .toStringAsFixed(1);
                        String remainedTime =
                            docs[index].data()["remainedTime"] == null
                                ? '...'
                                : (docs[index].data()["remainedTime"] / 60)
                                    .toStringAsFixed(1);
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
                          subtitle: Text(
                              '$remainedDistance km left,$remainedTime min left'),
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
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(lat, long),
        ),
      );
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
