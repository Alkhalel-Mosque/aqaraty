import 'package:aqaraty/api/api.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:aqaraty/models/user.dart';
import 'package:aqaraty/utils/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CoreProvider extends ChangeNotifier {
  User? user;
  ParseUser? parseUser;
  Api api = Api();
  List<RealEstate> realEstates = [];
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

  featchData() async {
    // try {
    final res = await api.fetchAllItems();
    realEstates = res;
    print("fetchAllItems===================================");

    print("items from API: $res");
    notifyListeners();
    // } catch (e) {
    //   print(e);
    // }
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

  newupdateRealEstate(RealEstate realEstate) async {
    try {
      final res = await api.updatePropertyWithPermissionCheck(realEstate);
      realEstates.removeWhere(
        (e) => e.id == realEstate.id,
      );
      realEstates.add(realEstate);
      notifyListeners();
      return res;
    } catch (e) {
      CustomToast.showToast(e.toString());
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

  void listenToConnectivityAndSync() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        final box = Hive.box<RealEstate>('pending_real_estates');

        final toUpload = box.values.toList();
        for (var realEstate in toUpload) {
          try {
            bool res = await addRealEstate(realEstate);
            if (res) {
              final key = box.keyAt(box.values.toList().indexOf(realEstate));
              await box.delete(key);

              CustomToast.showToast(
                  "✅ تم رفع العقار المحفوظ: ${realEstate.customerName}");
            }
          } catch (e) {
            CustomToast.showToast("❌ فشل في الرفع: $e");
          }
        }
      }
    });
  }
}
