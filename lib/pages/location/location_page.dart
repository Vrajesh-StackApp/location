import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/app/theme/app_theme.dart';
import 'package:location/app/widget/common_loader.dart';
import 'package:location/data/item/suggestion.dart';
import 'package:location/pages/location/location_controller.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colorPrimary,
        title: const Text(Constants.yourLocation),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ThemeData().colorScheme.copyWith(
                  primary: AppTheme.colorPrimary,
                ),
              ),
              child: TextFormField(
                controller: controller.searchController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: " Search here.."),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter address.";
                  }
                  return null;
                },
                onChanged: (value) {
                  controller.query.value = value;
                },
              ),
            ),
          ),
         Obx(() =>  Expanded(
           child: FutureBuilder(
             future: controller.query.value == "" ?
             null :
             controller.apiClient!.fetchSuggestions(controller.query.value, Localizations.localeOf(context).languageCode),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.none) {
                 return Container(); /*Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text("enterYourAddress"),
                  );*/
               } else if (snapshot.connectionState == ConnectionState.waiting) {
                 return const Center(child: CommonLoader());
               } else if (snapshot.connectionState == ConnectionState.done) {
                 if (snapshot.hasData) {
                   List<Suggestion> suggestionList = snapshot.data as List<Suggestion>;

                   debugPrint("suggestionList ==> $suggestionList");

                   return ListView.builder(
                     shrinkWrap: true,
                     itemBuilder: (context, index) {
                       return ListTile(
                         title: Text((suggestionList[index]).description),
                         onTap: () {
                           Navigator.pop(context, suggestionList[index]);
                         },
                       );
                     },
                     itemCount: suggestionList.length,
                   );
                 } else {
                   return const Center(
                     child: CommonLoader(),
                   );
                 }
               } else {
                 return const Text("else");
               }
             },
           ),
         )),
        ],
      ),
    );
  }
}

