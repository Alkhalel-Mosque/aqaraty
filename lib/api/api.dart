import 'dart:developer';
import 'dart:io';

import 'package:aqaraty/models/real_estate.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Api {
  Future<bool> login(String username, String password) async {
    final parseUser = ParseUser(username, password, null);
    var response = await parseUser.login();

    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<RealEstate>> fetchAllItems() async {
    print("fetchAllItems");
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('real_estate'))
          ..includeObject(['user']);

    final ParseResponse response = await queryBuilder.query();
    if (response.success && response.results != null) {
      print("object");
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
    // Save the object
    final res = await data.save();

    if (res.success) {
      final object = res.result as ParseObject;

      return object.objectId;
    } else {
      throw Exception('Failed to fetch data: ${res.error?.message}');
    }
  }

  Future<List<String>> uploadImages(List<String> imageFiles) async {
    // Handle image upload
    List<String> imageUrls = [];

    for (final imageFile in imageFiles) {
      if (imageFile.startsWith("https")) {
        imageUrls.add(imageFile);
        continue;
      }
      final file = File(imageFile);
      final parseFile = ParseFile(file);

      // Upload image to server
      var response = await parseFile.save();
      if (response.success) {
        var fileUrl = (response.result as ParseFile).url;
        imageUrls.add(fileUrl!);
      } else {
        print('Failed to upload image: ${response.error?.message}');
      }
    }

    return imageUrls;
  }

  Future<bool> updateRealEstate(RealEstate realEstate) async {
    try {
      // 1. Convert to ParseObject
      final parseObject = await realEstate.realEstateToParseObject(realEstate);

      // 2. Execute update
      final response = await parseObject.save();

      if (!response.success) {
        throw Exception('Update failed: ${response.error?.message}');
      }

      await uploadImages(realEstate.gallary ?? []);
      print('Successfully updated object: ${response.result.objectId}');
      return true;
    } catch (e) {
      print('Update error: $e');
      rethrow;
    }
  }

  Future<bool> deleteRealEstate(String objectId) async {
    try {
      final parseObject = ParseObject('real_estate')..objectId = objectId;
      final response = await parseObject.delete();

      if (!response.success) {
        throw Exception('Delete failed: ${response.error?.message}');
      }
      print('Successfully deleted object: $objectId');
      return true;
    } catch (e) {
      print('Delete error: $e');
      rethrow;
    }
  }

  Future<bool> updatePropertyWithPermissionCheck(RealEstate realEstate) async {
    try {
      final galary = await uploadImages(realEstate.gallary ?? []);
      realEstate.gallary = galary;
      final ParseCloudFunction function =
          ParseCloudFunction('updateRealEstate');

      final Map<String, dynamic> params =
          (await realEstate.realEstateToParseObject(realEstate)).toJson();

      final ParseResponse result = await function.execute(parameters: params);

      if (result.success && result.result != null) {
        print("Response: ${result.result}");
      } else {
        print("Error: ${result.error?.message}");
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
