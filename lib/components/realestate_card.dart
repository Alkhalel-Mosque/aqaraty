import 'package:aqaraty/components/custom_image.dart';
import 'package:aqaraty/enums/enums.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/pages/add_page.dart';
import 'package:aqaraty/router/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class RealestateCard extends StatelessWidget {
  const RealestateCard({super.key, required this.realEstate});
  final RealEstate realEstate;

  /// Return appropriate icon for message status
  Icon _getStatusIcon() {
    switch (realEstate.requestStatus) {
      case RequestStatus.pending:
        return Icon(Icons.access_time);
      case RequestStatus.complete:
        return Icon(Icons.done);

      case RequestStatus.canceled:
        return Icon(Icons.close);

      default:
        return Icon(Icons.warning_amber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Banner(
      message: realEstate.type!.arName,
      color: theme.colorScheme.primaryContainer,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      location: BannerLocation.topStart,
      child: InkWell(
        onTap: () {
          context.myPush(AddPage(realEstate: realEstate));
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CustomImage(path: realEstate.gallary?.firstOrNull),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topCenter,
                    end: AlignmentDirectional.bottomCenter,
                    colors: [
                      theme.colorScheme.onPrimary.withOpacity(0.5),
                      theme.colorScheme.onPrimary.withOpacity(1),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _getStatusIcon(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PieceOfInfo(
                          text: realEstate.getPrice,
                          iconData: Icons.attach_money,
                        ),
                        PieceOfInfo(
                          text: realEstate.getRoomsWithExtra,
                          iconData: Icons.door_back_door_outlined,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PieceOfInfo(
                          text: realEstate.getFloor ?? "",
                          iconData: Icons.home_work_outlined,
                        ),
                        PieceOfInfo(
                          text: realEstate.locationArea!,
                          iconData: Icons.location_on_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PieceOfInfo extends StatelessWidget {
  const PieceOfInfo({super.key, required this.text, required this.iconData});
  final String text;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(iconData),
      Text(text),
    ]);
  }
}
