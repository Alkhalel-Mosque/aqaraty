import 'package:aqaraty/models/user.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CoreProvider extends ChangeNotifier {
  User? user;
  ParseUser? parseUser;
  Future getCashedUser() async {
    final ParseUser? currentUser = await ParseUser.currentUser();
    parseUser = currentUser;
    print(currentUser);
    if (currentUser != null) {
      user = User.userFromParseUser(currentUser);
    } else {
      user = null;
    }
    notifyListeners();
  }
  

  Future<void> fullLogout() async {
    try {
      // 1. Clear current user session
      final response = await parseUser!.logout();

      // 2. Verify logout was successful
      if (response.success) {
        await getCashedUser();
      } else {
        print('Logout failed: ${response.error}');
      }

      // 3. Clear any local cached data (optional)
      await ParseCoreData().getStore().clear(); // Clears all local storage
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
