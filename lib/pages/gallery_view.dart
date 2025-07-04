import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryView extends StatefulWidget {
  final List<GalleryItem> galleryItems;
  final BoxDecoration? backgroundDecoration;
  final PageController? pageController;
  final ValueChanged<int>? onPageChanged;

  const GalleryView({
    super.key,
    required this.galleryItems,
    this.backgroundDecoration,
    this.pageController,
    this.onPageChanged,
  });

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          print(widget.galleryItems[index].imageUrl);

          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              widget.galleryItems[index].imageUrl, // Assuming this is now a URL
            ),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(
              tag: widget.galleryItems[index].id,
            ),
          );
        },
        itemCount: widget.galleryItems.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        backgroundDecoration: widget.backgroundDecoration,
        pageController: widget.pageController,
        onPageChanged: widget.onPageChanged,
      ),
    );
  }
}

class GalleryItem {
  final String id;
  final String imageUrl; // Changed from image to imageUrl for clarity

  GalleryItem({required this.id, required this.imageUrl});
}
