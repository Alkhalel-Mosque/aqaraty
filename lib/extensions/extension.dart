import 'dart:io';

import 'package:aqaraty/image/data/repositories/image_repository_impl.dart';
import 'package:aqaraty/image/domain/usecase.dart/upload_image.dart';

import 'package:aqaraty/models/real_estate.dart';
import 'package:flutter/material.dart';

extension SizedBoxInt on int {
  SizedBox get getWidthSizedBox => SizedBox(
        width: toDouble(),
      );
  SizedBox get getHightSizedBox => SizedBox(
        height: toDouble(),
      );
  int getCeilToThousand(int price) => (this * price / 1000).ceil() * 1000;
}

extension SearshFilter on String {
  String getSearshFilter() => replaceAll("أ", "ا")
      .replaceAll("ة", "ه")
      .replaceAll("إ", "ا")
      .replaceAll(" ", "")
      .toLowerCase();
}

extension MyDateTime on DateTime {
  String getYYYYMMDD() {
    String day = this.day > 9 ? "${this.day}" : "0${this.day}";
    String month = this.month > 9 ? "${this.month}" : "0${this.month}";
    String year = this.year.toString();
    return "$year-$month-$day";
  }
}

extension ListExtension on List {
  addOrDelete(Object object) {
    if (contains(object)) {
      remove(object);
    } else {
      add(object);
    }
  }
}

extension RealEstateImagesExt on RealEstate {
  Future<RealEstate> uploadGalleryImages(
      UploadImage repo, List<File> images) async {
    final uploadedImageIds = <String>[];

    for (var image in images) {
      final imageId = await repo(image.path);
      if (imageId != null) {
        uploadedImageIds.add(imageId);
      }
    }

    return copyWith(galleryImageIds: uploadedImageIds);
  }
}
