import 'package:flutter/material.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/app/routes/app_pages.dart';
import 'package:location/app/theme/app_theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the routes of your application.
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
      getPages: AppPages.routes,
    );
  }
}

