import 'package:aqaraty/components/map_view.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class My_map extends StatelessWidget {
  const My_map({super.key});

  @override
  Widget build(BuildContext context) {
    LatLng? lat;
    final ctl = MapController();
    return GestureDetector(
      onTap: () {
        context.myPush(MapView());
      },
      child: AbsorbPointer(
        child: FlutterMap(
          mapController: ctl,
          options: MapOptions(
            interactiveFlags: InteractiveFlag.none,
            center: LatLng(33.5449, 36.3233), // Damascus coordinates
            zoom: 17,
          ),
          children: [
            TileLayer(
              // Bring your own tiles
              maxZoom: 100,
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
              userAgentPackageName:
                  'com.example.app', // Add your app identifier
              // And many more recommended properties!
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: lat ?? LatLng(0, 0),
                  builder: (ctx) => Icon(Icons.location_pin, color: Colors.red),
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(33.545405, 36.322474),
                  builder: (ctx) => Icon(Icons.location_pin, color: Colors.red),
                ),
              ],
            ),

            // MarkerLayer(
            //   markers: [
            //     Marker(
            //       point: LatLng(_currentPosition?.latitude??0, _currentPosition?.longitude??0),
            //       builder: (ctx) =>
            //           Icon(Icons.location_pin, color: Colors.blue),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
