import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/data/item/place_service.dart';

class LocationController extends GetxController{
  TextEditingController searchController = TextEditingController();
  RxString query = "".obs;
  PlaceApiProvider? apiClient;

  String token = Get.arguments;

  @override
  void onInit() {
    debugPrint("token ==> $token");
    apiClient = PlaceApiProvider(token);
    super.onInit();
  }
}