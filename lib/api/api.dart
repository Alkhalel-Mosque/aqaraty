import 'dart:developer';

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

  Future<bool> addRealEstate(RealEstate realEstate) async {
    final data = await realEstate.realEstateToParseObject(realEstate);
    // Save the object
    final res = await data.save();
    if (res.success) {
      return true;
    } else {
      throw Exception('Failed to fetch data: ${res.error?.message}');
    }
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
}
