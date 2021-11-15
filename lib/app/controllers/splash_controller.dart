import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'rider_controller.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  final _userController = Get.find<RiderController>();

  @override
  void onInit() async {
    super.onInit();
    if (await isLocationPermissionGranted()) {
      if (_userController.isRiderNotLoggedIn) {
        Future.delayed(const Duration(seconds: 1))
            .then((_) => Get.offAllNamed(AppRoutes.INTRODUCTION));
      } else {
        // User is Signed In
        _userController
            .riderWithPhoneNumberIsExistInFirestore(
                _userController.currentRiderPhoneNumber!)
            .then((value) {
          if (value) {
            //  Rider Already Filled his Profile
            _userController.readCurrentUser().then((_) {
              if (_userController.rider.isApproved as bool) {
                Get.offAllNamed(AppRoutes.HOME);
              } else {
                Get.offAllNamed(AppRoutes.WAIT_FOR_APPROVAL);
              }
            });
          } else {
            _userController.rider.phoneNumber =
                _userController.currentRiderPhoneNumber;
            _userController.rider.id = _userController.currentRiderUID;
            Get.offAllNamed(AppRoutes.RIDER_PERSONAL_INFO);
          }
        });
      }
    } else {
      Get.offAllNamed(AppRoutes.LOCATION_ACCESS);
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    return Permission.locationWhenInUse.status.isGranted;
  }
}
