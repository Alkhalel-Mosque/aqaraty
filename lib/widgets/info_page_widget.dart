import 'package:aqaraty/models/real_estate.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Widget infoBoxWithActions(
  BuildContext ctx,
  IconData icon,
  String title,
  String value,
) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 22, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Row(
                children: [
                  Expanded(
                      child: Text(value, style: const TextStyle(fontSize: 12))),
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.blue),
                    onPressed: () async {
                      await _openUrl("tel:$value");
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.whatsapp,
                        color: Colors.green),
                    onPressed: () async {
                      await _openUrl("https://wa.me/$value");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Future<void> _openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('تعذر فتح الرابط: $url');
  }
}

Widget infoBox(
  RealEstate realEstate,
  IconData icon,
  String title,
  String value,
  bool addition,
) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 22, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Row(
                children: [
                  Text(value, style: const TextStyle(fontSize: 12)),
                  addition
                      ? Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (realEstate.iswithSalon == true)
                              const Text(
                                ' + صالون',
                                style: TextStyle(fontSize: 12),
                              ),
                            if (realEstate.iswithSofa == true)
                              const Text(
                                ' + صوفا',
                                style: TextStyle(fontSize: 12),
                              ),
                            if (realEstate.iswithRoof == true)
                              const Text(
                                ' + سطح',
                                style: TextStyle(fontSize: 12),
                              )
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
} // ===== Widgets مساعدة =====

Widget gridSection(String title, List<Widget> children, BuildContext context) {
  final theme = Theme.of(context);
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.focusColor)),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 1,
            childAspectRatio: 3.1,
            children: children,
          ),
        ],
      ),
    ),
  );
}

Widget cardSection(String title, List<Widget> children, BuildContext context) {
  final theme = Theme.of(context);
  return Card(
    color: theme.colorScheme.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.focusColor)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    ),
  );
}
