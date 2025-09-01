import 'package:aqaraty/components/map_view.dart';
import 'package:aqaraty/components/my_map.dart';
import 'package:aqaraty/extensions/extension.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/router/router.dart';
import 'package:aqaraty/widgets/my_autocomplete.dart';
import 'package:aqaraty/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapViewSc extends StatefulWidget {
  final RealEstate realEstate;
  const MapViewSc({super.key, required this.realEstate});

  @override
  State<MapViewSc> createState() => _MapViewScState();
}

class _MapViewScState extends State<MapViewSc> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الموقع",
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.outline,
              ),
            ),
            10.getHightSizedBox,
            MyAutoComplete(
              realEstate: widget.realEstate,
              labelText: "الموقع",
              onChanged: (p0) => widget.realEstate.locationArea = p0,
              initVal: widget.realEstate.locationArea,
              suffixIcon: widget.realEstate.coords == null
                  ? IconButton(
                      onPressed: () {
                        context.myPush(MapView(
                          coords: widget.realEstate.coords,
                          onSave: (p1) {
                            widget.realEstate.coords = p1;
                            setState(() {});
                          },
                        ));
                      },
                      icon: const FaIcon(FontAwesomeIcons.mapLocationDot),
                    )
                  : const Icon(Icons.location_on_outlined),
              onSelected: (p0) {
                widget.realEstate.locationArea = p0;
                setState(() {});
              },
              data: locations,
            ),
            if (widget.realEstate.coords != null) 10.getHightSizedBox,
            if (widget.realEstate.coords != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                    height: 200,
                    child: MyMap(
                      isEdite: true,
                      coords: widget.realEstate.coords,
                      onSave: (p0) {
                        widget.realEstate.coords = p0;
                        setState(() {});
                      },
                    )),
              ),
            10.getHightSizedBox,
            MyTextFormField(
              realEstate: widget.realEstate,
              labelText: "علامة",
              initVal: widget.realEstate.locationMark,
              onChanged: (p0) => widget.realEstate.locationMark = p0,
            ),
          ],
        ),
      ),
    );
  }
}
