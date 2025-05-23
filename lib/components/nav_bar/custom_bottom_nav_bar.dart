// import 'package:alkhalil_system/features/main/components/nav_icons.dart';
// import 'package:alkhalil_system/features/main/widget/navigat_item.dart';
// import 'package:flutter/material.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   final Function(int) onItemTapped;
//   final int selectedIndex;

//   const CustomBottomNavBar({
//     super.key,
//     required this.onItemTapped,
//     required this.selectedIndex,
//   });

//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;

//     return Container(
//       width: width - 10,
//       padding: EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(40),
//           topRight: Radius.circular(40),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(listicon.length, (index) {
//           return NavigatItem(
//             icon: listicon[index],
//             isSelected: widget.selectedIndex == index,
//             onTap: () => widget.onItemTapped(index),
//           );
//         }),
//       ),
//     );
//   }
// }
