// import 'package:alkhalil_system/core/constants/theme.dart';
// import 'package:flutter/material.dart';

// class NavigatItem extends StatelessWidget {
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const NavigatItem({
//     super.key,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Matrix4 transform;
//     final List<BoxShadow> boxShadow = [];
//     if (isSelected) {
//       transform = Matrix4.translationValues(0, -17, 0);
//       boxShadow.add(BoxShadow(
//         color: MainColor.principleBeige,
//         spreadRadius: 1,
//         blurRadius: 5,
//         offset: Offset(0, 2),
//       ));
//     } else {
//       transform = Matrix4.translationValues(0, 0, 0);
//     }
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 150),
//         curve: Curves.easeInOut,
//         transform: transform,
//         padding: isSelected ? EdgeInsets.all(4) : null,
//         decoration: BoxDecoration(
//           color: isSelected ? MainColor.secondaryBlue1 : Colors.black,
//           shape: BoxShape.circle,
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: isSelected ? MainColor.principleBeige : Colors.black,
//             shape: BoxShape.circle,
//             boxShadow: boxShadow,
//           ),
//           child: Icon(
//             icon,
//             color: isSelected ? Colors.black : Colors.white,
//             size: isSelected ? 37 : 30,
//           ),
//         ),
//       ),
//     );
//   }
// }
