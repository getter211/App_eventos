// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   MapboxMapController? mapController;

//   final CameraPosition initialCameraPosition = const CameraPosition(
//     target: LatLng(20.9668080244894, -89.59508711199662),
//     zoom: 12.0,
//   );

//   void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mapa de eventos'),
//       ),
//       body: MapboxMap(
//         accessToken: 'pk.eyJ1IjoiZ2V0dGVyMjExIiwiYSI6ImNseWx5OHZwczBkODkyaW9uNHozbHljOGwifQ.Ap5XRcybXFpu68x-zI6_yw',
//         initialCameraPosition: initialCameraPosition,
//         onMapCreated: _onMapCreated,
//       ),
//     );
//   }
// }
