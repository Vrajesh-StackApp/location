import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/app/constants/constants.dart';
import 'package:location/data/item/suggestion.dart';

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final dynamic sessionToken;

  // String apiKey = Platform.isIOS
  //     ? StringResources.IosAPIKe
  //     : StringResources.AndroidAPIKey;

  final apiKey = "AIzaSyB_kIX5UrOzY9KC14LVNRAIsZCkx3xBXeA";

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:in&key=$apiKey&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));

    debugPrint("Response ==> ${response.body}");

    if (response.statusCode == HttpStatus.ok) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        debugPrint("result ==> $result");
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  distance(double lat1, double lat2, double long1, double long2) async {
    debugPrint("Distance lat1 ==> $lat1");
    debugPrint("Distance long1 ==> $long1");
    debugPrint("Distance lat2 ==> $lat2");
    debugPrint("Distance long2 ==> $long2");

    final request =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$lat1,$lat2&destinations=$long1,$long2&key=${Constants.googleApiKey}";
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        debugPrint("distance result-->$result");
        // return result['predictions']
        //     .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
        //     .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}


