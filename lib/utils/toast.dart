import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static const String noPermissionError = "لاتملك الصلاحيات الكافية";
  static const String succesfulMessage = "تمت العملية بنجاح";
  static const String copySuccsed = "تم النسخ إلى الحافظة!";

  static showToast(String content) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
