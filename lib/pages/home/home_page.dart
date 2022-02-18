import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/app/theme/app_theme.dart';
import 'package:location/app/widget/common_loader.dart';
import 'package:location/pages/home/home_controller.dart';

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

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
          controller.goToTheLake(controller.googleCompleter);
        },
        backgroundColor: AppTheme.colorPrimary,
        child: const Icon(Icons.my_location),
      );

  Widget? _homeBody() => Obx(() => controller.latitude.value != 0.0 && controller.latitude.value != 0.0
      ? Stack(
          children: [
            GoogleMap(
              markers: controller.markers,
              mapType: controller.currentMapType!.value,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(target: LatLng(controller.latitude.value, controller.longitude.value), zoom: 15, tilt: 20),
              onMapCreated: (GoogleMapController googleMapController) {
                controller.googleCompleter.complete(googleMapController);
              },
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                /*Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onTap: () {
                      debugPrint("_handlePressButton ==>");
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
                ),*/
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FloatingActionButton(
                        onPressed: () {
                          // controller.animate();
                          openBottomSheet();
                        },
                        tooltip: 'Toggle',
                        backgroundColor: AppTheme.colorPrimary,
                        child: const Icon(Icons.layers)),
                  ),
                ),
              ],
            )
          ],
        )
      : const CommonLoader(
          color: AppTheme.colorPrimary,
        ));

  openBottomSheet() {
    return Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.35,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: controller.mapImageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return Obx(() => GestureDetector(
                    onTap: () {
                      controller.selectedMapIndex.value = index;
                      controller.onMapTypeButtonPressed(controller.mapImageList[index].mapType!);
                      Navigator.pop(context);
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: index == controller.selectedMapIndex.value ? AppTheme.colorPrimary : Colors.transparent,
                            ),
                          ),
                        ),
                        Center(child: Image.asset(controller.mapImageList[index].imagePath!)),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ),
      elevation: 20.0,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
    );
  }
}
