import 'package:get/get.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/pages/home/home_binding.dart';
import 'package:location/pages/home/home_page.dart';
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
  ];
}
