import 'dart:io';

import 'package:aqaraty/utils/toast.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ImageService {
  Future<String?> uploadImage(String imagePath) async {
    final file = File(imagePath);
    final parseFile = ParseFile(file);
    final response = await parseFile.save();
    if (response.success) {
      final savedFile = response.result as ParseFile;
      final remoteUrl = savedFile.url;

      if (remoteUrl == null || remoteUrl.isEmpty) {
        return null;
      }

      return remoteUrl;
    } else {
      CustomToast.showToast('❌ فشل رفع الصورة: ${response.error?.message}');
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages(List<String> imagePaths) async {
    List<String> uploadedUrls = [];

    for (final path in imagePaths) {
      final url = await uploadImage(path);

      if (url != null) {
        uploadedUrls.add(url);
      }
    }

    return uploadedUrls;
  }
}
