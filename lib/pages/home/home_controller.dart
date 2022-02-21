import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/app/constants/image_constatnts.dart';
import 'package:location/data/item/map_image.dart';
import 'package:location/data/item/place_service.dart';
import 'package:location/data/item/suggestion.dart';
import 'package:location/data/item/uuid.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final Completer<GoogleMapController> googleCompleter = Completer();
  TextEditingController searchController = TextEditingController();
  TextEditingController startAddressController = TextEditingController();
  TextEditingController destinationAddressController = TextEditingController();

  PlaceApiProvider? apiProvider;
  Position? currentPosition;
  RxString? currentAddress = ''.obs;

  Rx<FocusNode> startAddressFocusNode = Rx(FocusNode());
  Rx<FocusNode> destinationAddressFocusNode = Rx(FocusNode());

  RxString startAddress = ''.obs;
  RxString destinationAddress = ''.obs;
  RxString placeDistance = ''.obs;

  PolylinePoints? polylinePoints;
  Rx<Map<PolylineId, Polyline>> polyLines = Rx({});
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  final sessionToken = Uuid().v4();

  Position? destinationCoordinates;
  Position? startCoordinates;

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxInt selectedMap = 0.obs;
  Rx<MapType>? currentMapType = Rx(MapType.normal);
  Rx<Map<MarkerId, Marker>> markers = Rx({});

  RxList<MapImage> mapImageList = <MapImage>[].obs;
  RxInt selectedMapIndex = 0.obs;

  @override
  void onInit() {
    getLocation();
    apiProvider = PlaceApiProvider(sessionToken);
    addMapImage();
    super.onInit();
  }

  addMapImage() {
    mapImageList.value = [
      MapImage(imagePath: ImageConstants.googleDefaultIcon, mapType: MapType.normal),
      MapImage(imagePath: ImageConstants.googleSatelliteIcon, mapType: MapType.hybrid),
      MapImage(imagePath: ImageConstants.googleTrafficIcon, mapType: MapType.terrain),
    ];
  }

  onMapTypeButtonPressed(MapType mapType) {
    currentMapType!.value = mapType;
  }

  getLocation() async {
    MarkerId markerId = const MarkerId('Home');
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude;
    longitude.value = position.longitude;

    debugPrint("==> latitude --> " + latitude.toString() + " longitude --> " + longitude.toString());

    markers.value[markerId] = Marker(markerId: markerId, position: LatLng(latitude.value, longitude.value));
    update();
  }

  Future<void> goToTheLake(Completer<GoogleMapController> _controller) async {
    CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799, target: LatLng(latitude.value, longitude.value), tilt: 59.440717697143555, zoom: 19.151926040649414);

    final GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  openPlacePicker() async {
    final sessionToken = Uuid().v4();

    debugPrint("my session Token :- $sessionToken");

    final Suggestion result = await Get.toNamed(Constants.locationRoute, arguments: sessionToken);

    if (result != null) {
      debugPrint("Our Result:--$result");
      startAddressController.text = result.description;
      startAddress.value = result.description;
    }
  }

  openPlacePicker2() async {
    final sessionToken = Uuid().v4();

    debugPrint("my session Token :- $sessionToken");

    final Suggestion result = await Get.toNamed(Constants.locationRoute, arguments: sessionToken);

    if (result != null) {
      debugPrint("Our Result2:--$result");
      destinationAddressController.text = result.description;
      destinationAddress.value = result.description;
    }
  }

  getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(currentPosition!.latitude, currentPosition!.longitude);

      Placemark place = p[0];

      currentAddress!.value = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      startAddressController.text = currentAddress!.value;
      startAddress.value = currentAddress!.value;
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<bool> calculateDistance() async {
    try {
      List<Location> startPlaceMark = await locationFromAddress(startAddress.value);
      List<Location> destinationPlaceMark = await locationFromAddress(destinationAddress.value);

      if (startPlaceMark != null && destinationPlaceMark != null) {
        Position startCoordinates = startAddress == currentAddress
            ? Position(
                speed: 0,
                accuracy: 0,
                altitude: 0,
                heading: 0,
                speedAccuracy: 0,
                timestamp: null,
                latitude: currentPosition!.latitude,
                longitude: currentPosition!.longitude)
            : Position(
                speed: 0,
                accuracy: 0,
                altitude: 0,
                heading: 0,
                speedAccuracy: 0,
                timestamp: null,
                latitude: startPlaceMark[0].latitude,
                longitude: startPlaceMark[0].longitude);
        Position destinationCoordinates = Position(
            speed: 0,
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speedAccuracy: 0,
            timestamp: null,
            latitude: destinationPlaceMark[0].latitude,
            longitude: destinationPlaceMark[0].longitude);
        apiProvider!
            .distance(startPlaceMark[0].latitude, startPlaceMark[0].longitude, destinationPlaceMark[0].latitude, destinationPlaceMark[0].longitude);

        MarkerId startMarkerId = MarkerId('$startCoordinates');
        MarkerId destinationMarkerId = MarkerId('$BitmapDescriptor.defaultMarker');

        addMarker(
            LatLng(
              startCoordinates.latitude,
              startCoordinates.longitude,
            ),
            '$startCoordinates',
            BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: 'Start Point',
              snippet: startAddress.value,
            ));

        addMarker(
            LatLng(
              destinationCoordinates.latitude,
              destinationCoordinates.longitude,
            ),
            '$destinationCoordinates',
            BitmapDescriptor.defaultMarkerWithHue(90),
            infoWindow: InfoWindow(
              title: 'Destination Point',
              snippet: destinationAddress.value,
            ));

        // // Adding the markers to the list
        // markers.value[startMarkerId] = startMarker!;
        // markers.value[destinationMarkerId] = destinationMarker!;

        debugPrint('START COORDINATES: $startCoordinates');
        debugPrint('DESTINATION COORDINATES: $destinationCoordinates');

        Position northeastCoordinates;
        Position southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny = (startCoordinates.latitude <= destinationCoordinates.latitude) ? startCoordinates.latitude : destinationCoordinates.latitude;
        double minx =
            (startCoordinates.longitude <= destinationCoordinates.longitude) ? startCoordinates.longitude : destinationCoordinates.longitude;
        double maxy = (startCoordinates.latitude <= destinationCoordinates.latitude) ? destinationCoordinates.latitude : startCoordinates.latitude;
        double maxx =
            (startCoordinates.longitude <= destinationCoordinates.longitude) ? destinationCoordinates.longitude : startCoordinates.longitude;

        southwestCoordinates =
            Position(speed: 0, accuracy: 0, altitude: 0, heading: 0, speedAccuracy: 0, timestamp: null, latitude: miny, longitude: minx);
        northeastCoordinates =
            Position(speed: 0, accuracy: 0, altitude: 0, heading: 0, speedAccuracy: 0, timestamp: null, latitude: maxy, longitude: maxx);

        await getPolyline(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        placeDistance.value = totalDistance.toStringAsFixed(2);
        debugPrint('DISTANCE: $placeDistance km');

        return true;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return false;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  addMarker(LatLng position, String id, BitmapDescriptor descriptor, {InfoWindow? infoWindow}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position, infoWindow: infoWindow!);
    markers.value[markerId] = marker;
  }

  getPolyline(Position start, Position destination) async {
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
      'AIzaSyB_kIX5UrOzY9KC14LVNRAIsZCkx3xBXeA', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }

  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
    polyLines.value[id] = polyline;
  }
}
