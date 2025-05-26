import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController ctl = MapController();

  LatLng? markerPosition;
  bool isSelecting = false;

  void _startSelection() {
    setState(() {
      isSelecting = true;
    });
  }

  void _deleteMarker() {
    setState(() {
      markerPosition = null;
      isSelecting = false;
    });
  }

  void _confirmLocation() {
    if (markerPosition != null) {
      Navigator.pop(context, markerPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: ctl,
            options: MapOptions(
              center: LatLng(33.5449, 36.3233),
              zoom: 17,
              onTap: (tapPosition, latlng) {
                if (isSelecting) {
                  setState(() {
                    markerPosition = latlng;
                    isSelecting = false;
                  });
                }
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
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _startSelection,
                  icon: Icon(Icons.add_location),
                  label: Text(markerPosition == null ? "إضافة" : "تعديل"),
                ),
                if (markerPosition != null)
                  ElevatedButton.icon(
                    onPressed: _confirmLocation,
                    icon: Icon(Icons.check),
                    label: Text("تأكيد"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                if (markerPosition != null)
                  ElevatedButton.icon(
                    onPressed: _deleteMarker,
                    icon: Icon(Icons.delete),
                    label: Text("حذف"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
