import 'dart:io';

import 'package:aqaraty/api/api.dart';
import 'package:aqaraty/image/data/repositories/image_repository_impl.dart';
import 'package:aqaraty/api/local_data/currency2.dart';

import 'package:aqaraty/image/data/repositories/service.dart';

import 'package:aqaraty/image/domain/usecase.dart/upload_image.dart';

import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/models/user.dart';
import 'package:aqaraty/plugins/preferences_service.dart';
import 'package:aqaraty/utils/toast.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CoreProvider extends ChangeNotifier {
  UploadImage repo =
      UploadImage(ImageRepositoryImpl(imageService: ImageService()));

  User? user;
  ParseUser? parseUser;
  Api api = Api();
  List<RealEstate> realEstates = [];
  ThemeMode themeMode = ThemeMode.system;
  final _prefs = PreferencesService();
  bool isDark = false;
  Map<Currency, double> exchangeRates = {
    Currency.USD: 1.0,
    Currency.SYP: 15000.0, // قيمة افتراضية
  };

  CoreProvider() {
    _loadExchangeRates();
    loadTheme();
  }

  Future<void> _loadExchangeRates() async {
    final sypRate = await _prefs.getDouble("syp_rate") ?? 15000.0;
    exchangeRates[Currency.SYP] = sypRate;
    notifyListeners();
  }

  Future<void> updateExchangeRate(Currency currency, double rate) async {
    exchangeRates[currency] = rate;
    await _prefs.setDouble("${currency.name.toLowerCase()}_rate", rate);
    notifyListeners();
  }

  int? convertPrice(int? price, Currency? from, Currency to) {
    if (price == null || from == null) return null;
    final baseInUsd = price / exchangeRates[from]!;
    return (baseInUsd * exchangeRates[to]!).round();
  }

  Future<void> loadTheme() async {
    final saved = await _prefs.getDarkMode();

    isDark = saved;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    await _prefs.setDarkMode(value);

    isDark = value;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future getCashedUser() async {
    final ParseUser? currentUser = await ParseUser.currentUser();
    parseUser = currentUser;

    if (currentUser != null) {
      user = User.userFromParseUser(currentUser);
    } else {
      user = null;
    }
    notifyListeners();
  }

  featchData() async {
    // try {
    final res = await api.fetchAllItems();
    realEstates = res;

    notifyListeners();
    // } catch (e) {
    //   print(e);
    // }
  }

  /// تحديث عقار محدد من السيرفر
  Future<void> refreshRealEstate(String realEstateId) async {
    try {
      final res = await api.fetchAllItems();
      realEstates = res;
      notifyListeners();
    } catch (e) {
      CustomToast.showToast('خطأ في تحديث البيانات: $e');
    }
  }

  addRealEstate(RealEstate realEstate) async {
    try {
      final res = await api.addRealEstate(realEstate);
      if (res is String) {
        realEstate.id = res;
        realEstates.add(realEstate);
      }
      notifyListeners();
      return res is String;
    } catch (e) {
      CustomToast.showToast(e.toString());
      return false;
    }
  }

  Future<bool> newupdateRealEstate(RealEstate realEstate) async {
    try {
      final parseObject = await realEstate.realEstateToParseObject(realEstate);
      final response = await parseObject.save();

      if (response.success) {
        final updatedObject = response.results?.first as ParseObject;

        final gallery = updatedObject.get<List<dynamic>>('gellary') ?? [];

        final index = realEstates.indexWhere((e) => e.id == realEstate.id);
        if (index != -1) {
          realEstates[index] =
              realEstate.copyWith(galleryImageIds: gallery.cast<String>());
          notifyListeners();
        }

        // ✅ Update Hive cache with the latest data
        final box = await Hive.openBox<RealEstate>('real_estates_cache');
        await box.put(realEstate.id, realEstates[index]);

        return true;
      }
      return false;
    } catch (e) {
      CustomToast.showToast('خطأ في التحديث: $e');
      return false;
    }
  }

  deleteRealEstate(String id) async {
    try {
      final res = await api.deleteRealEstate(id);
      notifyListeners();
      return res;
    } catch (e) {
      CustomToast.showToast(e.toString());
      return false;
    }
  }

  Future<void> fullLogout() async {
    try {
      final response = await parseUser!.logout();

      if (response.success) {
        await getCashedUser();
      } else {
        CustomToast.showToast('Logout failed: ${response.error}');
      }

      await ParseCoreData().getStore().clear();
    } catch (e) {
      CustomToast.showToast('Logout error: $e');
    }
  }

  Future<void> syncPendingProperties() async {
    try {
      final box = await Hive.openBox<RealEstate>('pending_real_estates');
      final properties = box.values.toList();

      for (final property in properties) {
        try {
          // نفذ رفع الصور والعقار
          final updatedProperty = await uploadPropertyWithImages(property);

          await box.delete(property.key);
        } catch (e) {
          CustomToast.showToast("❌ فشل مزامنة العقار ${property.id}: $e");
        }
      }
    } catch (e) {
      CustomToast.showToast('❌ خطأ عام في المزامنة: $e');
    }
  }

  Future<RealEstate> uploadPropertyWithImages(RealEstate property) async {
    final uploadedUrls = <String>[];

    final localPaths = [
      ...?property.localGalleryImagePaths,
      ...?property.galleryImageIds
          ?.where((id) => id.startsWith("file://"))
          .map((id) => id.replaceFirst("file://", "")),
    ];

    if (localPaths.isNotEmpty) {
      for (final path in localPaths) {
        try {
          final file = File(path);
          if (await file.exists()) {
            final url = await repo(file.path);
            if (url != null) {
              uploadedUrls.add(url);
            } else {
              CustomToast.showToast("❌ فشل رفع الصورة: $path");
              throw Exception('فشل في رفع الصورة');
            }
          } else {
            CustomToast.showToast("⚠️ الملف غير موجود محليًا: $path");
          }
        } catch (e) {
          CustomToast.showToast('❌ خطأ في رفع الصورة $path: $e');
          rethrow;
        }
      }
    } else {
      CustomToast.showToast("ℹ️ لا توجد صور محلية للرفع.");
    }

    final updatedProperty = property.copyWith(
      galleryImageIds: {
        ...?property.galleryImageIds?.where((id) => id.startsWith("http")),
        ...uploadedUrls,
      }.toList(),
      localGalleryImagePaths: null,
    );

    final success = property.id == null
        ? await addRealEstate(updatedProperty)
        : await newupdateRealEstate(updatedProperty);

    if (success) {
      final box = await Hive.openBox<RealEstate>('real_estates_cache');
      await box.put(updatedProperty.id, updatedProperty);

      for (final path in localPaths) {
        try {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          CustomToast.showToast('❌ خطأ في حذف الملف المحلي: $path - $e');
        }
      }
    } else {
      CustomToast.showToast('❌ فشل رفع العقار: ${property.id}');
      throw Exception('فشل في رفع العقار');
    }

    return updatedProperty;
  }
}
