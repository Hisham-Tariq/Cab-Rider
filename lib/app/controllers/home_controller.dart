import 'dart:io';

import 'package:cab_rider_its/app/generated/assets.dart';
import 'package:cab_rider_its/app/models/dashboard_tile_item.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final List<DashboardTileItem> dashboardItems = [
    DashboardTileItem("Completed Trips", Assets.dashboardCompleted, () => Get.toNamed(AppRoutes.COMPLETED_TIPS)),
    DashboardTileItem("Current Trip", Assets.dashboardPending, () => Get.toNamed(AppRoutes.CURRENT_TRIP)),
    DashboardTileItem("Balance", Assets.dashboardWallet, () => Get.toNamed(AppRoutes.BALANCE)),
    DashboardTileItem("Sign Out", Assets.dashboardLogout, () async {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(AppRoutes.INTRODUCTION);
    }),
  ];

  @override
  onInit() {
    super.onInit();
    _saveDeviceToken();
  }

  _saveDeviceToken() async {
    // Get the current user
    String uid = FirebaseAuth.instance.currentUser!.uid;
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = FirebaseFirestore.instance.collection('rider').doc(uid).collection('tokens').doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
}
