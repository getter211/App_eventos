// import 'package:flutter/material.dart';
// import 'package:mapbox_search/mapbox_search.dart';

// class PlaceSearchProvider with ChangeNotifier {
//   final GeoCoding geoCoding;
//   List<MapBoxPlace> _places = [];

//   List<MapBoxPlace> get places => _places;

//   PlaceSearchProvider(String apiKey) : geoCoding = GeoCoding(apiKey: apiKey);

//   Future<void> searchPlaces(String query) async {
//     if (query.isNotEmpty) {
//       try {
//         var response = await geoCoding.getPlaces(query);
//         if (response.success != null) {
//           _places = response.success!;
//         } else {
//           // print('Error: ${response.e}');
//         }
//       } catch (e) {
//         print('Error: $e');
//       }
//     } else {
//       _places = [];
//     }
//     notifyListeners();
//   }

//   void clearPlaces() {
//     _places = [];
//     notifyListeners();
//   }
// }
