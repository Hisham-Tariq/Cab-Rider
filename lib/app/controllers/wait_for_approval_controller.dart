import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:get/get.dart';

import 'rider_controller.dart';

class WaitForApprovalController extends GetxController {
  checkRiderApproval() {
    var controller = Get.find<RiderController>();
    controller.readCurrentUser().then((_) {
      if (controller.rider.isApproved as bool) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.snackbar(
          'Account Approval',
          'Your account has been not approved yet please try checking it later',
        );
      }
    });
  }
}
