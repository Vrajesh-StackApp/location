import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/app/constants/constants.dart';
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
              markers: Set<Marker>.of(controller.markers.value.values),
              mapType: controller.currentMapType!.value,
              polylines: Set<Polyline>.of(controller.polyLines.value.values),
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
                Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      commonMapTextFormFiled(
                          labelText: Constants.sourceLocation,
                          icon: (Icons.adjust_rounded),
                          iconColor: AppTheme.colorPrimary,
                          controller: controller.startAddressController,
                          focusNode: controller.startAddressFocusNode.value,
                          function: () {
                            FocusScope.of(Get.context!).requestFocus(FocusNode());
                            controller.openPlacePicker();
                          },
                          onSaved: (String value) {
                            controller.startAddress.value = value;
                          }),
                      const SizedBox(height: 10),
                      commonMapTextFormFiled(
                        labelText: Constants.destination,
                        icon: (Icons.location_on),
                        iconColor: AppTheme.colorPrimary,
                        controller: controller.destinationAddressController,
                        focusNode: controller.destinationAddressFocusNode.value,
                        function: () {
                          FocusScope.of(Get.context!).requestFocus(FocusNode());
                          controller.openPlacePicker2();
                        },
                        onSaved: (String value) {
                          controller.destinationAddress.value = value;
                        },
                      ),
                    ],
                  ),
                ),
                controller.placeDistance.value.isNotEmpty
                    ? Text(
                        '${Constants.distance} : ${controller.placeDistance.value} km',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                Container(
                  height: 35,
                  decoration: BoxDecoration(color: AppTheme.colorPrimary, borderRadius: BorderRadius.circular(12)),
                  child: MaterialButton(
                    onPressed: (controller.startAddress.value != '' && controller.destinationAddress.value != '')
                        ? () async {
                            controller.startAddressFocusNode.value.unfocus();
                            controller.destinationAddressFocusNode.value.unfocus();

                            if (controller.markers.value.isNotEmpty) controller.markers.value.clear();
                            if (controller.polyLines.value.isNotEmpty) controller.polyLines.value.clear();
                            if (controller.polylineCoordinates.isNotEmpty) {
                              controller.polylineCoordinates.clear();
                            }
                            controller.placeDistance.value = '';

                            controller.calculateDistance();
                          }
                        : () {
                            debugPrint("null receive");
                          },
                    child: const Text(
                      "calculate distance",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FloatingActionButton(
                        onPressed: () {
                          openBottomSheet();
                        },
                        tooltip: 'Toggle',
                        heroTag: 'Map Types',
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

  Widget commonMapTextFormFiled(
      {TextEditingController? controller,
      String? labelText,
      IconData? icon,
      Color? iconColor,
      FocusNode? focusNode,
      required Function onSaved,
      required Function function}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextFormField(
        onTap: () {
          function();
        },
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: AppTheme.colorPrimary)
          ),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: AppTheme.colorPrimary)
          ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: AppTheme.colorPrimary)
          ),
          labelText: labelText,
          fillColor: Colors.white60,
          filled: true,
          focusColor: AppTheme.colorPrimary,
          labelStyle: const TextStyle(fontSize: 12,color: AppTheme.colorPrimary,),
          prefixIcon: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        controller: controller,
        focusNode: focusNode,
        onSaved: (newValue) => onSaved,
      ),
    );
  }
}
