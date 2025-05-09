import 'package:aqaraty/api/api.dart';
import 'package:aqaraty/pages/home_page.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Api api = Api();
  final ctl = MapController();
  LatLng? lat;
  Position? _currentPosition;
  String _locationMessage = "Press button to get location";
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationMessage = "Getting location...";
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationMessage = "Location services are disabled";
          _isLoading = false;
        });
        return;
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = "Location permissions are denied";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationMessage = "Location permissions are permanently denied";
          _isLoading = false;
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = position;
        _locationMessage = "Location fetched successfully!";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error getting location: $e";
        _isLoading = false;
      });
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      // final res = await api.login(username, password);
      final res = await api.fetchAllItems();
      if (false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful!")),
        );
        // Navigate to HomePage after login
        context.myPushReplacment(HomePage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid username or password!")),
        );
      }
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     setState(() {});
    //     _getCurrentLocation();
    //   },
    // );
    // ctl.mapEventStream.listen(
    //   (event) {
    //     setState(() {});
    //     lat = event.center;
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Hide password
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("Login"),
              ),
              // Text("${lat}"),
              // Expanded(
              //   // height: 100,
              //   // width: 100,
              //   child: FlutterMap(
              //     mapController: ctl,
              //     options: MapOptions(
              //       center: LatLng(33.5449, 36.3233), // Damascus coordinates
              //       zoom: 17,
              //     ),
              //     children: [
              //       TileLayer(
              //         // Bring your own tiles
              //         maxZoom: 100,

              //         urlTemplate:
              //             'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
              //         userAgentPackageName:
              //             'com.example.app', // Add your app identifier
              //         // And many more recommended properties!
              //       ),
              //       MarkerLayer(
              //         markers: [
              //           Marker(
              //             point: lat ?? LatLng(0, 0),
              //             builder: (ctx) =>
              //                 Icon(Icons.location_pin, color: Colors.red),
              //           ),
              //         ],
              //       ),
              //       MarkerLayer(
              //         markers: [
              //           Marker(
              //             point: LatLng(33.545405, 36.322474),
              //             builder: (ctx) =>
              //                 Icon(Icons.location_pin, color: Colors.red),
              //           ),
              //         ],
              //       ),
              //       MarkerLayer(
              //         markers: [
              //           Marker(
              //             point: LatLng(_currentPosition?.latitude??0, _currentPosition?.longitude??0),
              //             builder: (ctx) =>
              //                 Icon(Icons.location_pin, color: Colors.blue),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // )
         
            ],
          ),
        ),
      ),
    );
  }
}
