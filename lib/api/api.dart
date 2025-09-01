import 'dart:developer';

import 'package:aqaraty/image/domain/repositories/image_repository.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/utils/toast.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Api {
  final ImageRepository? imageRepository;

  Api([this.imageRepository]);

  Future<bool> login(String username, String password) async {
    final parseUser = ParseUser(username, password, null);
    var response = await parseUser.login();

    return response.success;
  }

  Future<List<RealEstate>> fetchAllItems() async {
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('real_estate'))
          ..includeObject(['user']);

    final ParseResponse response = await queryBuilder.query();
    if (response.success && response.results != null) {
      return (response.results as List<ParseObject>)
          .map((e) => RealEstate.realEstateFromParseObject(e))
          .toList();
    } else {
      log(response.error.toString());
      throw Exception('Failed to fetch data: ${response.error?.message}');
    }
  }

  Future<String?> addRealEstate(RealEstate realEstate) async {
    final data = await realEstate.realEstateToParseObject(realEstate);
    final res = await data.save();

    if (res.success) {
      final object = res.result as ParseObject;

      final freshRealEstate = RealEstate.realEstateFromParseObject(object);
      realEstate.galleryImageIds = freshRealEstate.galleryImageIds;

      return object.objectId;
    } else {
      throw Exception('Failed to save data: ${res.error?.message}');
    }
  }

  Future<bool> deleteRealEstate(String objectId) async {
    try {
      final parseObject = ParseObject('real_estate')..objectId = objectId;
      final response = await parseObject.delete();

      if (!response.success) {
        throw Exception('Delete failed: ${response.error?.message}');
      }
      CustomToast.showToast('تم حذف العقار');
      return true;
    } catch (e) {
      CustomToast.showToast('Delete error: $e');
      rethrow;
    }
  }

  Future<bool> updatePropertyWithPermissionCheck(RealEstate realEstate) async {
    try {
      final function = ParseCloudFunction('updateRealEstate');
      final Map<String, dynamic> params =
          (await realEstate.realEstateToParseObject(realEstate)).toJson();

      CustomToast.showToast(
          "DEBUG: Params sent to cloud function: ${params['gallery'] ?? params['gellary']}");
      CustomToast.showToast("DEBUG: Full params: $params");

      final ParseResponse result = await function.execute(parameters: params);

      if (result.success && result.result != null) {
        CustomToast.showToast("Response: ${result.result}");
        return true;
      } else {
        CustomToast.showToast(
            "Error updating real estate: ${result.error?.message}");
        return false;
      }
    } catch (e) {
      CustomToast.showToast(
          "Exception in updatePropertyWithPermissionCheck: $e");
      return false;
    }
  }
}
