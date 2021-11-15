
import 'package:get/get.dart';
import '../controllers/rider_proffesional_info_controller.dart';


class RiderProffesionalInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiderProffesionalInfoController>(() => RiderProffesionalInfoController());
        // Get.put<RiderProffesionalInfoController>(RiderProffesionalInfoController());
  }
}