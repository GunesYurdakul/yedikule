import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class YedikuleMap extends StatefulWidget {
  final Completer<GoogleMapController> controller;

  const YedikuleMap({Key? key, required this.controller}) : super(key: key);

  @override
  State<YedikuleMap> createState() => _YedikuleMapState();
}

class _YedikuleMapState extends State<YedikuleMap> {
  Set<Polyline> polylines = <Polyline>{};
  String? stepText;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.993057, 28.923205),
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
  late List<Marker> markers;

  @override
  void initState() {
    getPolyPoints();
    getCurrentLocation();
    markers = [
      buildMarker('Golden Gate', goldenGate),
      buildMarker('Hazine Kulesi', hazineKulesi),
      buildMarker('Dungeon Tower', dungeonTower),
      buildMarker('South Tower', southTower),
      buildMarker('Small Tower', smallTower),
      buildMarker('Tower of 3rd Ahmet', towerOf3rdAhmet),
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
    return Stack(
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
        if (stepText != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orange.withAlpha(120),
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                height: 80,
                child: Text(
                  stepText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
      ],
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
    markers.forEach((Marker marker) {
      if (currentLocation != null) {
        var distance = Geolocator.distanceBetween(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
          marker.position.latitude,
          marker.position.longitude,
        );
        if (distance < 8) {
          setState(() {
            stepText = "You have arrived to ${marker.markerId.value}";
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
            color: const Color(0xFF7B61FF),
            width: 6,
          ),
        );
      },
    );
  }

  buildMarker(String id, LatLng position) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      id,
                      style: const TextStyle(fontSize: 20),
                    ),
                    /*                     
                      ADD DESCRIPTION  MAYBE
                      Text(
                        id,
                        style: TextStyle(fontSize: 20),
                      ),
                    */
                    ElevatedButton(
                        child: Text('Go to $id'),
                        onPressed: () {
                          stepText = 'Follow the directions!';
                          Navigator.pop(context);
                          _drawPath(position);
                        }),
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
