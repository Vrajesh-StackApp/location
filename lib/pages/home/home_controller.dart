import 'dart:async';
import 'dart:math';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/app/constants/constants.dart';

class HomeController extends GetxController{

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxInt selectedMap = 0.obs;
  Rx<MapType>? currentMapType = Rx(MapType.normal);
  Set<Marker> markers = {};

  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

  onMapTypeButtonPressed(MapType mapType) {
    currentMapType?.value = mapType;
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      debugPrint("==> latitude --> " + latitude.toString() + " longitude --> " + longitude.toString());

    markers.add(Marker(markerId: const MarkerId('Home'), position: LatLng(latitude.value, longitude.value)));
    update();

  }

  Future<void> goToTheLake(Completer<GoogleMapController> _controller) async {

      CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude.value, longitude.value),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    final GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }



}
