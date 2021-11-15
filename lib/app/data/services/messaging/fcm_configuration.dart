import 'dart:async';
import 'package:flutter/services.dart';
export 'foreground.dart';
export 'background.dart';
export 'onclick.dart';

Future<void> clearNotifications() async {
  try {
    const platform = MethodChannel('notifications');
    final result = await platform.invokeMethod('clearAppNotifications');
    print(result);
    print('Message Cleared');
  } on PlatformException catch (e) {
    print("Failed to clear notifications: '${e.message}'.");
  }
}
