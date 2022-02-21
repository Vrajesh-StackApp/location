import 'package:get/get.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/pages/home/home_binding.dart';
import 'package:location/pages/home/home_page.dart';
import 'package:location/pages/location/location_binding.dart';
import 'package:location/pages/location/location_page.dart';
import 'package:location/pages/splash/splash_binding.dart';
import 'package:location/pages/splash/splash_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Constants.splashRoute,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Constants.homeRoute,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Constants.locationRoute,
      page: () => const LocationPage(),
      binding: LocationBinding(),
    )
  ];
}
