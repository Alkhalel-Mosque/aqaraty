import 'package:flutter/material.dart';

extension MyRouter on BuildContext {
  Future<T> myPush<T>(Widget child) async {
    return await Navigator.of(this).push(
      MaterialPageRoute(
        builder: (_) => child,
      ),
    );
  }

  Future<T> myPushReplacment<T>(Widget child) async {
    return await Navigator.of(this).pushReplacement(
      MaterialPageRoute(
        builder: (_) => child,
      ),
    );
  }

  Future<T> myPushReplacmentAll<T>(Widget child) async {
    return await Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => child,
      ),
      (__) => false,
    );
  }
}
