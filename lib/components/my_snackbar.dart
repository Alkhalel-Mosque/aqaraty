import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MySnackBar {
  static showMySnackBar(
    String content, {
    ContentType? contentType,
    String? title,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_LONG,
      webShowClose: true,
    );
  }

  static Future<T?> showMyBottomSheet<T>(
    BuildContext context,
    Widget widget,
  ) async {
    return await showModalBottomSheet<T>(
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      // backgroundColor: color9,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => widget,
    );
  }

  static Future<bool> showDeleteDialig(BuildContext context) async {
    return await showTowOptionDialog(
      context: context,
      content: "message will only deleted from this device",
      agreeText: "Yes",
      refuseText: "No",
      title: "Clear this chat?",
    );
  }

  static Future<bool> showYesNoDialog(
      BuildContext context, String content) async {
    return await showTowOptionDialog(
      context: context,
      content: content,
      agreeText: "Yes",
      refuseText: "No",
      title: "Warning",
    );
  }

  static Future<bool> showTowOptionDialog({
    required BuildContext context,
    String? title,
    required String content,
    required String agreeText,
    required String refuseText,
  }) async {
    return await showDialog(
          context: context,
          // barrierColor: dialogBackground.withOpacity(0.1),
          builder: (context) {
            return AlertDialog(
              // backgroundColor: dialogBackground,
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: title == null ? null : Text(title),
              content: Text(content),
              actions: [
                TextButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      overlayColor: MaterialStatePropertyAll(Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3)),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      refuseText,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    )),
                TextButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      overlayColor:
                          MaterialStatePropertyAll(Colors.red.withOpacity(0.3)),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      agreeText,
                      style: const TextStyle(color: Colors.red),
                    )),
              ],
            );
          },
        ) ??
        false;
  }
}

enum ContentType {
  warning,
  failure,
  success,
  help,
}
