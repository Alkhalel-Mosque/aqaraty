import 'package:aqaraty/components/map_view.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MyMap extends StatefulWidget {
  final LatLng? coords;
  final void Function(LatLng?) onSave;

  const MyMap({super.key, this.coords, required this.onSave});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late LatLng? lat = widget.coords;
  final ctl = MapController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.myPush(MapView(
          coords: lat,
          onSave: (p1) {
            lat = p1;
            widget.onSave.call(p1);
            if (p1!=null) {
            ctl.move(p1, 17);
              
            }
            setState(() {});
          },
        ));
      },
      child: AbsorbPointer(
        child: FlutterMap(
          mapController: ctl,
          options: MapOptions(
            interactiveFlags: InteractiveFlag.none,
            center:lat?? LatLng(33.5449, 36.3233), // Damascus coordinates
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
          ],
        ),
      ),
    );
  }
}
