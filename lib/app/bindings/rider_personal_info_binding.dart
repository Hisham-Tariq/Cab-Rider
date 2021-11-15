
import 'package:get/get.dart';
import '../controllers/rider_personal_info_controller.dart';


class RiderPersonalInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiderPersonalInfoController>(() => RiderPersonalInfoController());
        // Get.put<RiderPersonalInfoController>(RiderPersonalInfoController());
  }
}