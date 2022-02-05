import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/app/theme/app_theme.dart';
import 'package:location/app/widget/common_loader.dart';
import 'package:location/pages/home/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  HomeController controller = Get.put(HomeController());
  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController searchController = TextEditingController();

  bool isOpened = false;
  AnimationController? animationController;
  Animation<Color>? animateColor;
  Animation<double>? animateIcon;
  Animation<double>? translateButton;

  @override
  void initState() {
    animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController!);
    translateButton = Tween<double>(
      begin: 56,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: animationController!,
      curve: const Interval(
        0.0,
        0.75,
      ),
    ));
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      animationController!.forward();
    } else {
      animationController!.reverse();
    }
    isOpened = !isOpened;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _homeBody(),
          floatingActionButton: _floatingActionButton(),
    ));
  }

  Widget? _floatingActionButton() => FloatingActionButton(
    onPressed: () {
      controller.goToTheLake(_controller);
    },
    backgroundColor: AppTheme.colorPrimary,
    child: const Icon(Icons.my_location),
  );

  Widget? _homeBody() => Obx(() =>
    controller.latitude.value != 0.0 && controller.latitude.value != 0.0
        ? Stack(
      children: [
        GoogleMap(
          markers: controller.markers,
          mapType: controller.currentMapType!.value,
          myLocationEnabled: true,
          mapToolbarEnabled: true,
          compassEnabled: false,
          initialCameraPosition: CameraPosition(target: LatLng(controller.latitude.value, controller.longitude.value), zoom: 15, tilt: 20),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: searchController,
                onSubmitted: (value) {

                },
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: "Search here",
                  border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.colorPrimary)),
                  contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Transform(
                    transform: Matrix4.translationValues(
                      translateButton!.value * 3.0,
                      0.0,
                      0.0,
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        controller.selectedMap.value = 2;
                        controller.onMapTypeButtonPressed(MapType.hybrid);
                        animate();
                      },
                      tooltip: 'Hybrid',
                      heroTag: "Hybrid",
                      backgroundColor: AppTheme.colorPrimary,
                      child: CircleAvatar(
                        radius: controller.selectedMap.value == 2 ? 26.0 : 30.0,
                        backgroundImage: const AssetImage("assets/icons/ic_traffic-1x.png"),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                      translateButton!.value * 2.0,
                      0.0,
                      0.0,
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        controller.selectedMap.value = 1;
                        controller.onMapTypeButtonPressed(MapType.satellite);
                        animate();
                      },
                      backgroundColor: AppTheme.colorPrimary,
                      tooltip: 'Satellite',
                      heroTag: "Satellite",
                      child: CircleAvatar(
                        radius: controller.selectedMap.value == 1 ? 26.0 : 30.0,
                        backgroundImage: const AssetImage("assets/icons/ic_satellite-1x.png"),
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                      translateButton!.value,
                      0.0,
                      0.0,
                    ),
                    child: FloatingActionButton(
                      onPressed:() {
                        controller.selectedMap.value = 0;
                        controller.onMapTypeButtonPressed(MapType.normal);
                        animate();
                      },
                      backgroundColor: AppTheme.colorPrimary,
                      tooltip: 'Default',
                      heroTag: "Default",
                      child: CircleAvatar(
                        radius: controller.selectedMap.value == 0 ? 26.0 : 30.0,
                        backgroundImage: const AssetImage("assets/icons/ic_default-1x.png"),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      onPressed: animate,
                      tooltip: 'Toggle',
                      backgroundColor: AppTheme.colorPrimary,
                      child: Icon(
                        isOpened ? Icons.close : Icons.layers,
                      )
                  ),
                ],
              ),
            )
          ],
        )
      ],
    )
        : const CommonLoader(
      color: AppTheme.colorPrimary,
    )
  );


}
