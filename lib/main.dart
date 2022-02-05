import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/app/constants/utils.dart';
import 'package:location/app/theme/app_theme.dart';
import 'package:location/app/widget/common_loader.dart';
import 'package:location/pages/home/home_page.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: AppTheme.colorPrimary,
          fontFamily: AppTheme.fontName,
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: AppTheme.colorPrimary.withOpacity(0.2),
            selectionHandleColor: AppTheme.colorPrimary,
          )),
      initialRoute: Constants.splashRoute,
      getPages: [
        GetPage(name: Constants.splashRoute, page: () => const SplashPage()),
        GetPage(name: Constants.homeRoute, page: () => const HomePage()),
      ],
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    askPermission(Permission.location);
    Timer(const Duration(seconds: 5), () => Get.offNamed(Constants.homeRoute));
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/google_location_map_icon.svg",
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 10),
            const Text(
              Constants.homeAppBar,
              style: TextStyle(
                color: AppTheme.colorPrimary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                fontFamily: AppTheme.poppinsRegular,
              ),
            ),
            const SizedBox(height: 10),
            const CommonLoader(
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}

//thau?