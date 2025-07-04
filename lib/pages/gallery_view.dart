// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view_gallery.dart';

// class GalleryView extends StatefulWidget {
//   const GalleryView({super.key});


//   @override
//   State<GalleryView> createState() => _GalleryViewState();
// }

// class _GalleryViewState extends State<GalleryView> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: PhotoViewGallery.builder(
//       scrollPhysics: const BouncingScrollPhysics(),
//       builder: (BuildContext context, int index) {
//         return PhotoViewGalleryPageOptions(
//           imageProvider: AssetImage(widget.galleryItems[index].image),
//           initialScale: PhotoViewComputedScale.contained * 0.8,
//           heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
//         );
//       },
//       itemCount: galleryItems.length,
//       loadingBuilder: (context, event) => Center(
//         child: Container(
//           width: 20.0,
//           height: 20.0,
//           child: CircularProgressIndicator(
//             value: event == null
//                 ? 0
//                 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
//           ),
//         ),
//       ),
//       backgroundDecoration: widget.backgroundDecoration,
//       pageController: widget.pageController,
//       onPageChanged: onPageChanged,
//     ));
//   }
// }
