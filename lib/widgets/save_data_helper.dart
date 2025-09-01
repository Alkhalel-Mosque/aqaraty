import 'package:aqaraty/provider/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../models/real_estate.dart';

class SaveDataHelper {
  static Future<void> saveData(
    BuildContext context,
    WidgetRef ref,
    RealEstate realEstate,
    List<dynamic> newlyPickedImages,
    bool mounted,
  ) async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/images/loading.json", height: 100),
                const SizedBox(height: 16),
                const Text(
                  "جاري التحضير...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      final connected = await ref
          .read(imagesProvider(realEstate.id.toString()).notifier)
          .checkConnectivity();

      if (!connected) {
        if (mounted) {
          Navigator.of(context).pop(); // إغلاق ديالوج التحضير
          await ref
              .read(imagesProvider(realEstate.id.toString()).notifier)
              .saveOfflineData(realEstate, context, newlyPickedImages.cast());
          Future.delayed(const Duration(seconds: 2), () {
            _showSuccessDialog(context, "تم الحفظ بنجاح ✅", mounted);
          });
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
        }

        if (newlyPickedImages.isNotEmpty && mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset("assets/images/Loading.json", height: 100),
                      const SizedBox(height: 16),
                      const Text(
                        "جاري رفع الصور...",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        final bool success = await ref
            .read(imagesProvider(realEstate.id.toString()).notifier)
            .uploadOnline(realEstate, newlyPickedImages.cast());

        if (newlyPickedImages.isNotEmpty && mounted) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          if (success) {
            _showSuccessDialog(context, "تم الحفظ بنجاح ✅", mounted);
            if (mounted) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              });
            }
          } else {
            _showErrorDialog(context, "فشل في حفظ البيانات", mounted);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        _showErrorDialog(context, "حدث خطأ: ${e.toString()}", mounted);
      }
    }
  }

  static void _showSuccessDialog(
      BuildContext context, String message, bool mounted) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/images/true.json", height: 120),
              const SizedBox(height: 16),
              Text(message,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );

    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  static void _showErrorDialog(
      BuildContext context, String message, bool mounted) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/images/Failed.json", height: 120),
              const SizedBox(height: 16),
              Text("فشل الحفظ ❌\n$message",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("حاول مرة أخرى"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
