import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yedikule/game.dart';
import 'package:yedikule/question.dart';
import 'package:yedikule/scratcher_game.dart';

class YedikuleMap extends StatefulWidget {
  final Completer<GoogleMapController> controller;

  const YedikuleMap({Key? key, required this.controller}) : super(key: key);

  @override
  State<YedikuleMap> createState() => _YedikuleMapState();
}

class _YedikuleMapState extends State<YedikuleMap> {
  Set<Polyline> polylines = <Polyline>{};
  String? stepText;
  int step = 0;
  String? currentStepId;
  GameSettings? gameToStart;
  bool testMode = false;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.9929, 28.923205),
    zoom: 18,
  );
  static const LatLng goldenGate = LatLng(
    40.993127478999774,
    28.922618217766285,
  );
  static const LatLng dungeonTower = LatLng(
    40.99330436944092,
    28.924124948680404,
  );
  static const LatLng hazineKulesi = LatLng(
    40.993921078182616,
    28.923280388116837,
  );
  static const LatLng southTower = LatLng(
    40.99242016555428,
    28.923893943428993,
  );
  static const LatLng smallTower = LatLng(
    40.99219848006456,
    28.922771774232388,
  );
  static const LatLng towerOf3rdAhmet = LatLng(
    40.99363410815218,
    28.92217867076397,
  );
  static const LatLng yedikule = LatLng(
    40.9932,
    28.9231,
  );
  late List<Marker> markers;
  Map<String, GameSettings?> settings = {
    'Golden Gate': GameSettings('Golden Gate', [
      GameStep(
        question: QuestionAnswer(
            "Yedikule Altınkapı hangi tarihsel dönemde yapılmıştır?",
            [
              "Osmanlı dönemi",
              "Bizans dönemi",
            ],
            1),
      ),
      GameStep(
        imagePaths: [
          "lib/assets/golden_gate/1.jpg",
          "lib/assets/golden_gate/2.png",
        ],
      ),
    ]),
    'Hazine Kulesi': GameSettings('Hazine Kulesi', [
      GameStep(
        question: QuestionAnswer(
            "Hazine Kulesi hangi dönemde yapılmıştır?",
            [
              "Bizans dönemi",
              "Osmanlı dönemi",
            ],
            1),
      ),
      GameStep(
        imagePaths: [
          "lib/assets/hazine_kulesi/1.jpg",
          "lib/assets/hazine_kulesi/2.jpg",
        ],
      ),
    ]),
    /**
     * Fatih Sultan Mehmet yapıya kaç kule ekletmiştir (eklemiştir) ve Yedikule ismini almıştır?
        4
        3
        2
      Geçmiş dönemlerde yapıdaki kulelerin üstü hangi çatı türüyle kapatılmıştır?
        Soğan
        Konik / Külah
        Tonoz
     */
    'Yedikule': GameSettings(
      'Yedikule',
      [
        GameStep(
          question: QuestionAnswer(
            "Fatih Sultan Mehmet yapıya kaç kule ekletmiştir ve Yedikule ismini almıştır?",
            [
              "3",
              "4",
              "2",
            ],
            0,
          ),
        ),
        GameStep(
          imagePaths: [
            "lib/assets/axo/1.jpeg",
            "lib/assets/axo/2.jpg",
          ],
        ),
        GameStep(
          question: QuestionAnswer(
            "Geçmiş dönemlerde yapıdaki kulelerin üstü hangi çatı türüyle kapatılmıştır?",
            [
              "Soğan",
              "Tonoz",
              "Konik / Külah",
            ],
            2,
          ),
        ),
        GameStep(
          imagePaths: [
            "lib/assets/axo/3.jpg",
            "lib/assets/axo/4.JPG",
          ],
        ),
      ],
    ),
  };

  @override
  void initState() {
    getPolyPoints();
    getCurrentLocation();
    markers = [
      buildMarker(
        'Golden Gate',
        goldenGate,
        active: true,
      ),
      buildMarker(
        'Hazine Kulesi',
        hazineKulesi,
        active: true,
      ),
      buildMarker(
        'Dungeon Tower',
        dungeonTower,
      ),
      buildMarker(
        'South Tower',
        southTower,
      ),
      buildMarker(
        'Small Tower',
        smallTower,
      ),
      buildMarker(
        'Tower of 3rd Ahmet',
        towerOf3rdAhmet,
      ),
      buildMarker(
        'Yedikule',
        yedikule,
        active: true,
      ),
    ];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YedikuleMap oldWidget) {
    _goBackToYedikule();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Time Travel: Yedikule'),
            IconButton(
              onPressed: () {
                setState(() {
                  testMode = !testMode;
                });
              },
              icon: Icon(
                testMode ? Icons.stop_circle : Icons.play_circle_fill,
                size: 30,
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              widget.controller.complete(controller);
            },
            markers: ([
                      if (currentLocation != null)
                        Marker(
                          markerId: const MarkerId("currentLocation"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueAzure),
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                        ),
                    ] +
                    markers)
                .toSet(),
            polylines: polylines,
            onTap: (details) {
              print(details);
            },
          ),
          if (step == 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lime.withAlpha(200),
                  ),
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 100,
                  child: Text(
                    stepText!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          else if (step == 2)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lime.withAlpha(200),
                  ),
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 160,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        stepText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (gameToStart != null)
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Game(
                                  settings: gameToStart!,
                                  onCompleted: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Start discovering!",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> _goBackToYedikule() async {
    final GoogleMapController controller = await widget.controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDhE_Iq9bhqozcMW5MigOtiiLv1en9Ywmo', // Your Google Map Key
      PointLatLng(goldenGate.latitude, goldenGate.longitude),
      PointLatLng(southTower.latitude, southTower.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        _checkIfClose();
        setState(() {});
      },
    );
  }

  _checkIfClose() {
//    stepText = null;
    markers.forEach((Marker marker) {
      if (currentLocation != null) {
        var distance = Geolocator.distanceBetween(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
          marker.position.latitude,
          marker.position.longitude,
        );
        if (distance < 20 && marker.markerId.value == currentStepId) {
          setState(() {
            stepText = "You arrived to the ${marker.markerId.value}";
            gameToStart = settings[marker.markerId.value];
            step = 2;
          });
        }
      }
    });
  }

  _drawPath(LatLng locationToGo) {
    setState(
      () {
        polylines = {};
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [
              LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
              locationToGo
            ],
            color: Color.fromARGB(255, 25, 190, 219),
            width: 6,
          ),
        );
      },
    );
  }

  buildMarker(String id, LatLng position, {bool active = false}) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          active ? BitmapDescriptor.hueRed : BitmapDescriptor.hueOrange),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      id,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /*                     
                      ADD DESCRIPTION  MAYBE
                      Text(
                        id,
                        style: TextStyle(fontSize: 20),
                      ),
                    */
                    ElevatedButton(
                      child: Text(
                        'Go to $id',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        if (testMode) {
                          stepText = "You arrived to the $id";
                          gameToStart = settings[id];
                          step = 2;
                        } else {
                          stepText = 'Follow the directions!';
                          step = 1;
                        }
                        currentStepId = id;
                        Navigator.pop(context);
                        _drawPath(position);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
