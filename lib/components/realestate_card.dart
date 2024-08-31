import 'package:aqaraty/components/custom_image.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:flutter/material.dart';

class RealestateCard extends StatelessWidget {
  const RealestateCard({super.key, required this.realEstate});
  final RealEstate realEstate;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Banner(
      message: realEstate.type!.arName,
      color: theme.colorScheme.primaryContainer,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      location: BannerLocation.topStart,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const CustomImage(path: "assets/images/house_sample.jpg"),
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
                        text: realEstate.getFloor,
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
