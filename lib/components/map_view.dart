import 'package:aqaraty/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  final LatLng? coords;
  final void Function(LatLng?) onSave;
  const MapView({super.key, this.coords, required this.onSave});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController ctl = MapController();

  late LatLng? markerPosition = widget.coords;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final pos = await Geolocator.getCurrentPosition();
    ctl.move(LatLng(pos.latitude, pos.longitude), 17);
    if (markerPosition == null) {
      setState(() {
        markerPosition = LatLng(pos.latitude, pos.longitude);
      });
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return pos;
  }

  void _confirmLocation() {
    if (markerPosition != null) {
      widget.onSave.call(markerPosition);
      Navigator.pop(context, markerPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (markerPosition != null)
            FloatingActionButton(
              heroTag: "1",
              onPressed: _confirmLocation,
              backgroundColor: Colors.green[800],
              child: Icon(Icons.done),
            ),
          10.getHightSizedBox,
          FloatingActionButton(
            heroTag: "2",
            onPressed: _determinePosition,
            child: Icon(Icons.my_location_sharp),
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: ctl,
            options: MapOptions(
              center: markerPosition ?? LatLng(33.5449, 36.3233),
              zoom: 17,
              onTap: (tapPosition, latlng) {
                setState(() {
                  markerPosition = latlng;
                });
              },
            ),
            children: [
              TileLayer(
                maxZoom: 100,
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (markerPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: markerPosition!,
                      builder: (ctx) =>
                          Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            left: 0,
            top: 30,
            child: IconButton(
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
              icon: Icon(size: 40, Icons.arrow_forward_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
