import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/app/constants/image_constatnts.dart';
import 'package:location/data/item/map_image.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin{

  final Completer<GoogleMapController> googleCompleter = Completer();
  TextEditingController searchController = TextEditingController();

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxInt selectedMap = 0.obs;
  Rx<MapType>? currentMapType = Rx(MapType.normal);
  Set<Marker> markers = {};

  RxList<MapImage> mapImageList = <MapImage>[].obs;
  RxInt selectedMapIndex = 0.obs;

  @override
  void onInit() {
    getLocation();
    addMapImage();
    super.onInit();
  }

  addMapImage(){
    mapImageList.value = [
      MapImage(imagePath: ImageConstants.googleDefaultIcon,mapType: MapType.normal),
      MapImage(imagePath: ImageConstants.googleSatelliteIcon,mapType: MapType.hybrid),
      MapImage(imagePath: ImageConstants.googleTrafficIcon,mapType: MapType.terrain),
    ];
  }

  onMapTypeButtonPressed(MapType mapType) {
    currentMapType!.value = mapType;
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
