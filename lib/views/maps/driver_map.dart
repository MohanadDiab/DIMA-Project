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

class DriverMap extends StatefulWidget {
  const DriverMap({Key? key}) : super(key: key);
  @override
  State<DriverMap> createState() => DriverMapState();
}

class DriverMapState extends State<DriverMap>
    with AutomaticKeepAliveClientMixin {
  MapboxMapController? mapController;
  GeoPoint? sellerLocation;
  late LatLng destination;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  StreamSubscription<LocationData>? locationSubscription;
  var location = Location();
  final mapCompleter = Completer();
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

  Future<List<LineOptions>> getMultipleOptimalRoute(
      LatLng departure, List<Map<String, dynamic>> packedCollections) async {
    var returnResult = <LineOptions>[];
    for (Map packedCollection in packedCollections) {
      LatLng destination = packedCollection['destination'];
      String itemId = packedCollection['itemId'];
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://api.mapbox.com/directions/v5/mapbox/cycling/${departure.longitude},${departure.latitude};${destination.longitude},${destination.latitude}?access_token=pk.eyJ1Ijoic2hlbmdzaGVubGkiLCJhIjoiY2twZTA1MzVzMWpmbjJvbXVnMDd4aTQwZiJ9.UjJrmHYz6yPmy7jHT5RB_A&geometries=geojson'));
      print(Uri.parse(
          'https://api.mapbox.com/directions/v5/mapbox/cycling/${departure.longitude},${departure.latitude};${destination.longitude},${destination.latitude}?access_token=pk.eyJ1Ijoic2hlbmdzaGVubGkiLCJhIjoiY2twZTA1MzVzMWpmbjJvbXVnMDd4aTQwZiJ9.UjJrmHYz6yPmy7jHT5RB_A&geometries=geojson'));
      http.StreamedResponse response = await request.send();
      var _temp = <LatLng>[];
      var _tempGeoPoints = <GeoPoint>[];
      if (response.statusCode == 200) {
        final result =
            convert.jsonDecode(await response.stream.bytesToString());
        for (var i in result['routes'][0]['geometry']['coordinates']) {
          _temp.add(LatLng(i[1], i[0]));
          _tempGeoPoints.add(GeoPoint(i[1], i[0]));
        }
        await CloudService().setRequestStatus(
            userId: userId,
            docId: itemId,
            route: _tempGeoPoints,
            remainedDistance: result['routes'][0]['distance'].toDouble(),
            remainedTime: result['routes'][0]['duration'].toDouble());
        returnResult.add(LineOptions(
            geometry: _temp,
            lineColor: "#ff0000",
            lineWidth: 3.0,
            lineOpacity: 0.5,
            draggable: false));
      }
    }
    return returnResult;
  }

  Future<LineOptions> getOptimalRoute(
      LatLng departure, LatLng destination) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.mapbox.com/directions/v5/mapbox/cycling/${departure.longitude},${departure.latitude};${destination.longitude},${destination.latitude}?access_token=pk.eyJ1Ijoic2hlbmdzaGVubGkiLCJhIjoiY2twZTA1MzVzMWpmbjJvbXVnMDd4aTQwZiJ9.UjJrmHYz6yPmy7jHT5RB_A&geometries=geojson'));
    http.StreamedResponse response = await request.send();
    var _temp = <LatLng>[];
    var _tempGeoPoints = <GeoPoint>[];
    if (response.statusCode == 200) {
      final result = convert.jsonDecode(await response.stream.bytesToString());
      for (var i in result['routes'][0]['geometry']['coordinates']) {
        _temp.add(LatLng(i[1], i[0]));
        _tempGeoPoints.add(GeoPoint(i[1], i[0]));
      }
      await CloudService().setRoute(userId: userId, route: _tempGeoPoints);
      return LineOptions(
          geometry: _temp,
          lineColor: "#ff0000",
          lineWidth: 3.0,
          lineOpacity: 0.5,
          draggable: false);
    } else {
      print(response.reasonPhrase);
      return LineOptions();
    }
  }

  Map<String, dynamic> currentSituation = {
    'currentLocation': 0,
    'currentTask': [],
    'isCollected': false,
    'isCollectedRun': false,
    'isFinished': false
  };

  Future<void> updateMap() async {
    if (currentSituation['currentLocation'] == 0 ||
        currentSituation['currentTask'] == [0] ||
        currentSituation['isCollectedRun'] == false) {
      print('initialization unfinished.');
    } else {
      //what task should we do
      if (currentSituation['currentTask'].length == 0) {
        //status=-1,currently no task,clear the map
        await removeAll(mapController!);
        currentSituation['isFinished'] = true;
        print('clean everything on the map');
      } else {
        currentSituation['isFinished'] = false;
        if (!currentSituation['isCollected']) {
          //status=0, the item hasn't been collected.
          print('the item has not been collected');
          String assignedSeller =
              await CloudService().getAssignedSeller(userId: userId);
          GeoPoint sellerLocation =
              await CloudService().getSellerLocation(userId: assignedSeller);
          mapController!.symbols.forEach((symbol) {
            if (symbol.options.iconImage == 'bicycle-15') {
              mapController!.removeSymbol(symbol);
            }
          });
          mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: currentSituation['currentLocation'], zoom: 12),
          ));
          mapController?.addSymbol(_getSymbolOptions(
              currentSituation['currentLocation'], '', 'bicycle-15'));

          getOptimalRoute(currentSituation['currentLocation'],
                  LatLng(sellerLocation.latitude, sellerLocation.longitude))
              .then((computedLine) {
            mapController!.lines.forEach((line) {
              mapController!.removeLine(line);
            });
            mapController!.addLine(computedLine);
            setState(() {});
          });
          mapController!.addSymbol(_getSymbolOptions(
              LatLng(sellerLocation.latitude, sellerLocation.longitude),
              'seller',
              'restaurant-15'));
        } else {
          //status=1, the item has been collected.
          print('the item has been collected');
          List<Map<String, dynamic>> packedCollections = [];
          for (Map<String, dynamic> deliveringItem
              in currentSituation['currentTask']) {
            GeoPoint _location = deliveringItem['location'];
            packedCollections.add({
              'destination': LatLng(_location.latitude, _location.longitude),
              'itemId': deliveringItem['id']
            });
            Map<String, dynamic> symbolData = {};
            symbolData['name'] = deliveringItem['name'];
            symbolData['remainedDistance'] = deliveringItem['remainedDistance'];
            symbolData['remainedTime'] = deliveringItem['remainedTime'];
            mapController?.addSymbol(
                _getSymbolOptions(
                    LatLng(_location.latitude, _location.longitude),
                    '',
                    'mountain-15'),
                symbolData);
          }
          mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: currentSituation['currentLocation'], zoom: 12),
          ));
          mapController!.symbols.forEach((symbol) {
            if (symbol.options.iconImage == 'bicycle-15') {
              mapController!.removeSymbol(symbol);
            }
          });
          mapController?.addSymbol(_getSymbolOptions(
              currentSituation['currentLocation'], '', 'bicycle-15'));
          getMultipleOptimalRoute(
                  currentSituation['currentLocation'], packedCollections)
              .then((computedMultipleLine) {
            mapController!.lines.forEach((line) {
              mapController!.removeLine(line);
            });
            for (LineOptions computedLine in computedMultipleLine) {
              mapController!.addLine(computedLine);
            }
            setState(() {});
          });
        }
      }
    }
  }

  Future<void> updateSituation(
      {LatLng? currentLocation, List? currentTask, bool? isCollected}) async {
    if (currentLocation != null &&
        currentLocation != currentSituation['currentLocation']) {
      currentSituation['currentLocation'] = currentLocation;
      await updateMap();
    }
    if (currentTask != null &&
        currentTask.length != currentSituation['currentTask'].length) {
      currentSituation['currentTask'] = currentTask;
      await updateMap();
    }
    if (isCollected != null && isCollected != currentSituation['isCollected']) {
      await removeAll(mapController!);
      currentSituation['isCollected'] = isCollected;
      await updateMap();
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
    _showSnackBar(
        'Name:${symbol.data!["name"]},Remained Time: ${(symbol.data!["remainedTime"] / 60).toStringAsFixed(1)} min');
  }

  _onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
    CloudService().getAliveDriverRequests(userId: userId).listen((event) async {
      List taskList = [];
      for (QueryDocumentSnapshot<Map<String, dynamic>> deliveringItem
          in event.docs) {
        var task = deliveringItem.data();
        task['id'] = deliveringItem.id;
        taskList.add(task);
      }
      await updateSituation(currentTask: taskList);
    });
    CloudService().getDriverAsSnapshot(userId: userId).listen((event) async {
      currentSituation['isCollectedRun'] = true;
      await updateSituation(isCollected: event.data()!['is_collected']);
    });
    setState(() {});
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
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 5000, distanceFilter: 5);
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) async {
      LatLng _currentSituation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      await CloudService().setDriverLocation(
          userId: userId,
          location:
              GeoPoint(currentLocation.latitude!, currentLocation.longitude!));
      await updateSituation(currentLocation: _currentSituation);
    });
    final cameras =
        availableCameras().then((cameras) => firstCamera = cameras.first);
  }

  Future getMyCurrentLocation() async {
    mapController!.symbols.forEach((s) => print(s.options.iconImage));
    final myLocation = await Location().getLocation();
    return LatLng(myLocation.latitude!, myLocation.longitude!);
  }

  final items = ["item1", "item2", "item3", "item4"];

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.

    availableCameras().then((cameras) => firstCamera = cameras.first);
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
                    height: 265,
                    child: StreamBuilder(
                        stream: CloudService()
                            .getAliveDriverRequests(userId: userId),
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
                                      height: 265,
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        // showDialog(
                                                        //   context: context,
                                                        //   barrierDismissible:
                                                        //       true, // set to false if you want to force a rating
                                                        //   builder: (context) =>
                                                        //       _dialog,
                                                        // );
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                            return TakePictureScreen(
                                                              camera:
                                                                  firstCamera!,
                                                              userId: userId,
                                                              itemId:
                                                                  docs[index]
                                                                      .id,
                                                            );
                                                          }),
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              const Size(10, 5),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3))),
                                                      child:
                                                          Text('Take Picture'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {},
                                                      style: ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              const Size(10, 5),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3))),
                                                      child: Text('Call'),
                                                    ),
                                                  ],
                                                ),
                                              )
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
                    height: height * 0.22,
                    child: Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            'Retrieve Items',
                            textScaleFactor: 2,
                          ),
                          Text(
                            'Seller Location',
                            textScaleFactor: 1.15,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Via Dora Riparia, 14',
                            textScaleFactor: 1.15,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Divider(
                            height: 1.0,
                            indent: 60.0,
                            color: Colors.grey,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () async {
                                await CloudService()
                                    .setCollected(userId: userId);
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(30, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3))),
                              child: Text('Already Collected!'),
                            ),
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
            stream: CloudService().getAliveDriverRequests(userId: userId),
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
