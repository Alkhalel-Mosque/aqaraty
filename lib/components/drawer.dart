import 'package:aqaraty/components/my_snackbar.dart';
import 'package:aqaraty/pages/new_log.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({super.key});

  @override
  ConsumerState<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  double? containerHight = 0;
  late double w;

  @override
  Widget build(BuildContext context) {
    final coreProvRead = ref.read(coreProvider);

    w = MediaQuery.of(context).size.width * 0.9;
    return Drawer(
      width: w,
      child: Column(
        children: [
          Expanded(
              child: ListView(
            reverse: false,
            children: [
              UserAccountsDrawerHeader(
                onDetailsPressed: () {
                  setState(() {
                    containerHight == 0
                        ? containerHight = 180
                        : containerHight = 0;
                  });
                },
                decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor),
                accountName: Text(coreProvRead.user?.username ?? ""),
                accountEmail: Text(coreProvRead.user?.phonenumber ?? ""),
                currentAccountPicture: GestureDetector(
                  onTap: () {},
                  child: Hero(
                    tag: 0,
                    child: ClipOval(
                      child: SizedBox.square(
                          dimension: 100,
                          child: Image.asset("assets/images/profile.png")),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                  height: containerHight,
                  duration: const Duration(milliseconds: 100),
                  child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          title: const Text("Add Account"),
                          leading: const Icon(Icons.add),
                          onTap: () {},
                        ),
                        const Divider(color: Colors.grey),
                      ])),
              ListTile(
                title: const Text('Help'),
                leading: const Icon(
                  Icons.help_center,
                ),
                onTap: () async {
                  // MyRouter.myPush(context, GameWidget(game: MyGame()));
                },
              ),
            ],
          )),
          ListTile(
            title: const Text('Log out'),
            leading: const Icon(
              Icons.logout,
            ),
            subtitle: const Text('Logging out this account from this device'),
            onTap: () async {
              final res = await MySnackBar.showYesNoDialog(
                  context, "Are you sure you want to Log out?");
              if (res) {
                await coreProvRead.fullLogout();
                context.myPushReplacmentAll(LoginPage());
              }
            },
          ),
        ],
      ),
    );
  }
}

// LatLng? lat;
//      final ctl = MapController();
//     return FlutterMap(
//       mapController: ctl,
//       options: MapOptions(
//         center: LatLng(33.5449, 36.3233), // Damascus coordinates
//         zoom: 17,
//       ),
//       children: [
//         TileLayer(
//           // Bring your own tiles
//           maxZoom: 100,
//           urlTemplate:
//               'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
//           userAgentPackageName: 'com.example.app', // Add your app identifier
//           // And many more recommended properties!
//         ),
//         MarkerLayer(
//           markers: [
//             Marker(
//               point: lat ?? LatLng(0, 0),
//               builder: (ctx) => Icon(Icons.location_pin, color: Colors.red),
//             ),
//           ],
//         ),
//         MarkerLayer(
//           markers: [
//             Marker(
//               point: LatLng(33.545405, 36.322474),
//               builder: (ctx) => Icon(Icons.location_pin, color: Colors.red),
//             ),
//           ],
//         ),

//         // MarkerLayer(
//         //   markers: [
//         //     Marker(
//         //       point: LatLng(_currentPosition?.latitude??0, _currentPosition?.longitude??0),
//         //       builder: (ctx) =>
//         //           Icon(Icons.location_pin, color: Colors.blue),
//         //     ),
//         //   ],
//         // ),
//       ],
//     );
//   }
// }
