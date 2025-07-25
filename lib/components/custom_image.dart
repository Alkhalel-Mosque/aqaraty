import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({super.key, required this.path});
  final String? path;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: path == null
          ? Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
              height: 200,
            )
          : CachedNetworkImage(
              imageUrl: path!,
              height: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              cacheManager: DefaultCacheManager(),
            ),
    );
  }
}
