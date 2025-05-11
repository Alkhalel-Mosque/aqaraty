import 'package:aqaraty/models/real_estate.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Api {
  Future<bool> login(String username, String password) async {
    final parseUser = ParseUser(username, password, null);
    var response = await parseUser.login();
    print(response.result);
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<RealEstate>> fetchAllItems() async {
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('real_estate'))
          ..includeObject(['user']);
 

    final ParseResponse response = await queryBuilder.query();
    if (response.success && response.results != null) {
      return [];
      // return (response.results as List<ParseObject>).map((e) => e.,).toList();
    } else {
      throw Exception('Failed to fetch data: ${response.error?.message}');
    }
  }

  addRealEstate(RealEstate realEstate) async {
    final data = await realEstate.realEstateToParseObject(realEstate);
    // Save the object
    final res = await data.save();
    print(res.error);
  }
}
