import 'dart:io';

import 'package:aqaraty/extensions/extension.dart';
import 'package:aqaraty/image/data/repositories/image_repository_impl.dart';
import 'package:aqaraty/image/data/repositories/service.dart';
import 'package:aqaraty/image/domain/usecase.dart/upload_image.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/utils/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ImagesState {
  final List<String> initialUrls;
  final List<File> compressedFiles;
  final List<String> deletedImageIds;
  final List<int> pendingDeletion;

  const ImagesState({
    this.initialUrls = const [],
    this.compressedFiles = const [],
    this.deletedImageIds = const [],
    this.pendingDeletion = const [],
  });

  ImagesState copyWith({
    List<String>? initialUrls,
    List<File>? compressedFiles,
    List<String>? deletedImageIds,
    List<int>? pendingDeletion,
  }) {
    return ImagesState(
      initialUrls: initialUrls ?? this.initialUrls,
      compressedFiles: compressedFiles ?? this.compressedFiles,
      deletedImageIds: deletedImageIds ?? this.deletedImageIds,
      pendingDeletion: pendingDeletion ?? this.pendingDeletion,
    );
  }
}

class ImagesNotifier extends StateNotifier<ImagesState> {
  final String realEstateId;
  final Ref ref;
  final UploadImage imageRepo;
  ImagesNotifier(
    this.realEstateId,
    this.ref,
    this.imageRepo,
  ) : super(const ImagesState());

  void setInitialUrls(List<String> urls, {bool override = false}) {
    if (state.initialUrls.isEmpty || override) {
      state = state.copyWith(
        initialUrls: urls,
        compressedFiles: override ? [] : state.compressedFiles,
        deletedImageIds: override ? [] : state.deletedImageIds,
        pendingDeletion: override ? [] : state.pendingDeletion,
      );
    }
  }

  void addCompressedFiles(List<File> files) {
    state = state.copyWith(
      compressedFiles: [...state.compressedFiles, ...files],
    );
  }

  void markForDeletion(int index) {
    if (!state.pendingDeletion.contains(index)) {
      state = state.copyWith(
        pendingDeletion: [...state.pendingDeletion, index],
      );
    }
  }

  void unmarkForDeletion(int index) {
    if (state.pendingDeletion.contains(index)) {
      final newPendingDeletion = [...state.pendingDeletion]..remove(index);
      state = state.copyWith(pendingDeletion: newPendingDeletion);
    }
  }

  void confirmDeletion() {
    final sortedIndices = [...state.pendingDeletion]
      ..sort((a, b) => b.compareTo(a));
    print('=====================$sortedIndices');

    List<String> newInitialUrls = [...state.initialUrls];
    List<File> newCompressedFiles = [...state.compressedFiles];
    List<String> newDeletedImageIds = [...state.deletedImageIds];

    for (int index in sortedIndices) {
      if (index < state.initialUrls.length) {
        final imageId = state.initialUrls[index];
        newDeletedImageIds.add(imageId);
        newInitialUrls.removeAt(index);
      } else {
        final compIndex = index - state.initialUrls.length;
        if (compIndex >= 0 && compIndex < state.compressedFiles.length) {
          newCompressedFiles.removeAt(compIndex);
          print('==========================$compIndex');
        }
      }
    }

    state = state.copyWith(
      initialUrls: newInitialUrls,
      compressedFiles: newCompressedFiles,
      deletedImageIds: newDeletedImageIds,
      pendingDeletion: [],
    );
  }

  void clearLocalImages() {
    final serverImages =
        state.initialUrls.where((url) => url.startsWith("http")).toList();

    state = state.copyWith(
      initialUrls: serverImages,
      compressedFiles: [],
      deletedImageIds: [],
      pendingDeletion: [],
    );
  }

  List<dynamic> get allItems =>
      [...state.initialUrls, ...state.compressedFiles];
  void clearDeleted() {
    state = state.copyWith(deletedImageIds: []);
  }

  void setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {}
    });
  }

  Future<bool> checkConnectivity() async {
    try {
      final conn = await Connectivity().checkConnectivity();
      return conn != ConnectivityResult.none;
    } catch (e) {
      CustomToast.showToast('❌ خطأ في التحقق من الاتصال: $e');
      return false;
    }
  }

  Future<void> saveOfflineData(RealEstate realEstate, BuildContext ctx,
      List<File> newlyPickedImages) async {
    try {
      final savedImagePaths = await saveImagesLocally(newlyPickedImages);

      final propertyData = realEstate.copyWith(
        localGalleryImagePaths: savedImagePaths,
        galleryImageIds: [
          ...?realEstate.galleryImageIds,
          ...savedImagePaths.map((p) => 'file://$p')
        ],
      );

      final box = await Hive.openBox<RealEstate>('pending_real_estates');
      await box.add(propertyData);

      CustomToast.showToast("🚫 تم الحفظ للعمل دون اتصال");
      if (mounted) {
        Navigator.pop(ctx);
      }
    } catch (e) {
      CustomToast.showToast("❌ فشل في الحفظ دون اتصال");
    }
  }

  Future<List<String>> saveImagesLocally(List<File> newlyPickedImages) async {
    final saved = <String>[];
    final docsDir = await getApplicationDocumentsDirectory();
    final offlineDir = Directory('${docsDir.path}/offline_images');

    if (!await offlineDir.exists()) await offlineDir.create(recursive: true);

    for (final img in newlyPickedImages) {
      try {
        final ts = DateTime.now().millisecondsSinceEpoch;
        final newPath = '${offlineDir.path}/img_$ts.jpg';

        // التحقق من وجود الصورة قبل نسخها
        if (await img.exists()) {
          await img.copy(newPath);
          saved.add(newPath);
          CustomToast.showToast("✅ تم حفظ الصورة محلياً: $newPath");
        } else {
          CustomToast.showToast("⚠️ ملف الصورة غير موجود: ${img.path}");
        }
      } catch (e) {
        CustomToast.showToast("❌ خطأ في حفظ الصورة محلياً: $e");
      }
    }
    return saved;
  }

  /// مزامنة تلقائية مع العقار
  void _syncWithRealEstate() {
    final realEstate = ref
        .read(coreProvider)
        .realEstates
        .firstWhere((e) => e.id.toString() == realEstateId);

    final newInitialImages =
        (realEstate.localGalleryImagePaths?.isNotEmpty ?? false)
            ? realEstate.localGalleryImagePaths!
            : (realEstate.galleryImageIds ?? []);

    // ✅ لو تغيرت الصور، نحدث الحالة
    if (newInitialImages.toString() != state.initialUrls.toString()) {
      state = state.copyWith(initialUrls: newInitialImages);
    }
  }

  /// استدعاء يدوي للمزامنة (مثلاً بعد حفظ العقار)
  void refresh() => _syncWithRealEstate();

  /// تحديث حالة الصور من البيانات المحدثة في CoreProvider
  void refreshFromCore() {
    try {
      final realEstate = ref
          .read(coreProvider)
          .realEstates
          .firstWhere((e) => e.id.toString() == realEstateId);

      final updatedImages = realEstate.galleryImageIds ?? [];
      
      // تحديث الحالة مع الصور الجديدة
      state = state.copyWith(
        initialUrls: updatedImages,
        compressedFiles: [],
        deletedImageIds: [],
        pendingDeletion: [],
      );
    } catch (e) {
      // إذا لم يتم العثور على العقار، لا نفعل شيئاً
      print('Real estate not found for refresh: $realEstateId');
    }
  }
  Future<bool> uploadOnline(
      RealEstate realEstate, List<File> newlyPickedImages) async {
    final imagesNotifier =
        ref.read(imagesProvider(realEstate.id.toString()).notifier);
    final deletedImageIds = imagesNotifier.state.deletedImageIds;

    try {
      RealEstate updated = realEstate;

      final connected = await checkConnectivity();
      if (!connected) {
        return false;
      }

      // ✅ اجمع الصور الموجودة أصلاً
      final existingGallery = [...?realEstate.galleryImageIds];

      // ✅ ارفع الصور الجديدة
      List<String> uploadedUrls = [];
      if (newlyPickedImages.isNotEmpty) {
        for (final file in newlyPickedImages) {
          final url = await imageRepo(file.path); // ترفع وترجع رابط
          if (url != null) {
            uploadedUrls.add(url);
          }
        }
      }

      // ✅ دمج القديم + الجديد (مع حذف الصور المحددة)
      final mergedGallery = [
        ...existingGallery.where((id) => !deletedImageIds.contains(id)),
        ...uploadedUrls,
      ].toSet().toList(); // toSet() لتفادي التكرار

      // ✅ حدث العقار بالقائمة الجديدة
      updated = updated.copyWith(galleryImageIds: mergedGallery);

      // ✅ احفظ التغييرات في السيرفر
      final success = realEstate.id == null
          ? await ref.read(coreProvider).addRealEstate(updated)
          : await ref.read(coreProvider).newupdateRealEstate(updated);

      if (success) {
        // ✅ تحديث حالة الصور مع الصور الجديدة المرفوعة
        imagesNotifier.setInitialUrls(mergedGallery, override: true);
        imagesNotifier.clearDeleted(); // فضي قائمة المحذوف
        imagesNotifier.clearLocalImages(); // مسح الصور المحلية المؤقتة
      }

      return success;
    } catch (e) {
      CustomToast.showToast('❌ خطأ في الرفع: $e');
      return false;
    }
  }
}

final imagesProvider =
    StateNotifierProvider.family<ImagesNotifier, ImagesState, String>(
        (ref, realEstateId) {
  final repo = UploadImage(ImageRepositoryImpl(imageService: ImageService()));
  return ImagesNotifier(realEstateId, ref, repo);
});
