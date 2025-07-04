import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_file/open_file.dart';

class ImageView extends StatelessWidget {
  final List<String> images;

  const ImageView({super.key, required this.images});

  Future<void> _openImage(String image) async {
    await OpenFile.open(await getCachedImagePath(image));
  }

  Future<String?> getCachedImagePath(String imageUrl) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
    return fileInfo?.file.path;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SizedBox(
          width: 250,
          height: 250,
          child: InkWell(
            onTap: () {
              _openImage(images[index]);
            },
            child: CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              cacheManager: DefaultCacheManager(),
            ),
          ),
        ),
      ),
    );
  }

}
