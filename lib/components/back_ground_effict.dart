import 'package:flutter/material.dart';

Widget background(BuildContext context) {
  final theme = Theme.of(context);
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
          theme.colorScheme.surface,
        ],
      ),
    ),
  );
}

Widget circl1(BuildContext context) {
  final theme = Theme.of(context);
  return Positioned(
    top: -40,
    right: -40,
    child: Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  );
}

Widget circl2(BuildContext context) {
  final theme = Theme.of(context);
  return Positioned(
    bottom: -70,
    left: -70,
    child: Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  );
}
