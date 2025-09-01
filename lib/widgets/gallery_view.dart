import 'dart:io';

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
  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    widget.pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          final item = widget.galleryItems[index];
          final String url = item.imageUrl;

          ImageProvider imageProvider;

          if (_isValidImageUrl(url)) {
            imageProvider = CachedNetworkImageProvider(url);
          } else if (File(url).existsSync()) {
            imageProvider = FileImage(File(url)); // دعم ملفات محلية
          } else {
            imageProvider = const AssetImage('assets/placeholder.png');
          }

          return PhotoViewGalleryPageOptions(
            imageProvider: imageProvider,
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 2.0,
          );
        },
        itemCount: widget.galleryItems.length,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: event?.cumulativeBytesLoaded != null &&
                      event?.expectedTotalBytes != null
                  ? event!.cumulativeBytesLoaded /
                      event.expectedTotalBytes!.toDouble()
                  : null,
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              strokeWidth: 3,
            ),
          ),
        ),
        backgroundDecoration: widget.backgroundDecoration ??
            const BoxDecoration(color: Colors.black),
        pageController: widget.pageController,
        onPageChanged: widget.onPageChanged,
      ),
    );
  }
}

class GalleryItem {
  final String id;
  final String imageUrl;

  GalleryItem({required this.id, required this.imageUrl});
}
