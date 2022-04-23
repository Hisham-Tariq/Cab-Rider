import 'package:cab_rider_its/app/controllers/controllers.dart';
import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ui/utils/utils.dart';

class LocationAccessController extends GetxController {
  Future<bool> requestLocaionPermission() async {
    // await FirebaseAuth.instance.signOut();
    if (!(await Permission.locationWhenInUse.request().isGranted)) {
      showAppSnackBar(
        'Location',
        'Location permission must be granted in order to use the app',
      );
      return false;
    } else {
      if (!(await Permission.locationAlways.request().isGranted)) {
        showAppSnackBar(
          'Location',
          'Location permission must be granted in order to use the app',
        );
        return false;
      }
    }
    return true;
  }

  handleGrantAcess() async {
    var _userController = Get.find<RiderController>();
    if (await requestLocaionPermission()) {
      if (_userController.isRiderNotLoggedIn) {
        Future.delayed(const Duration(seconds: 1)).then((_) => Get.offAllNamed(AppRoutes.INTRODUCTION));
      } else {
        // User is Signed In
        _userController.riderWithPhoneNumberIsExistInFirestore(_userController.currentRiderPhoneNumber!).then((value) {
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
            _userController.rider.phoneNumber = _userController.currentRiderPhoneNumber;
            _userController.rider.id = _userController.currentRiderUID;
            Get.offAllNamed(AppRoutes.RIDER_PERSONAL_INFO);
          }
        });
      }
    }
  }
}
