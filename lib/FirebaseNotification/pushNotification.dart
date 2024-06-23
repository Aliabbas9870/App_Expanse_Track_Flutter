import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class PushNotification {
  static final _firebaseMess = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _firebaseMess.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _firebaseMess.getToken();
    Get.snackbar("Token", "Your Token $token");
  }
}
