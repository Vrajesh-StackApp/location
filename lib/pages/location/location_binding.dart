import 'package:get/get.dart';
import 'package:location/pages/location/location_controller.dart';

class LocationBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }

}