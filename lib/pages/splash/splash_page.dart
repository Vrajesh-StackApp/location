import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/app/constants/image_constatnts.dart';
import 'package:location/app/constants/utils.dart';
import 'package:location/app/theme/app_theme.dart';
import 'package:location/app/widget/common_loader.dart';
import 'package:permission_handler/permission_handler.dart';

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
              ImageConstants.googleLocationMapIcon,
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