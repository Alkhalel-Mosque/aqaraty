import 'dart:io';
import 'package:aqaraty/api/local_data/types_local.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.path,
    required this.realEstate,
  });

  final RealEstate realEstate;
  final String? path;

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      // 📌 لو مافيه path نرجع صورة حسب نوع العقار
      return _buildDefaultImage(realEstate.type);
    }

    if (path!.startsWith('http')) {
      // 📌 صورة من الانترنت
      return CachedNetworkImage(
        imageUrl: path!,
        height: 250,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        cacheManager: DefaultCacheManager(),
      );
    }

    if (path!.startsWith('file://')) {
      // 📌 صورة من ملف محلي
      return Image.file(
        File(path!.replaceFirst('file://', '')),
        fit: BoxFit.cover,
      );
    }

    return const SizedBox(); // 📌 fallback
  }

  /// دالة خاصة تعطي صورة افتراضية حسب النوع
  Widget _buildDefaultImage(Types? type) {
    switch (type) {
      case Types.buy:
        return Image.asset("assets/images/talpsh.png", fit: BoxFit.fill);
      case Types.rent:
        return Image.asset("assets/images/talps.png", fit: BoxFit.fill);
      case Types.sell:
        return Image.asset("assets/images/3rb.png", fit: BoxFit.fill);
      case Types.rentOut:
        return Image.asset("assets/images/3re.png", fit: BoxFit.fill);

      case null:
        throw UnimplementedError();
    }
  }
}
