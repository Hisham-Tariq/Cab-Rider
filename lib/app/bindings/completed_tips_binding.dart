
import 'package:get/get.dart';
import '../controllers/completed_tips_controller.dart';


class CompletedTipsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompletedTripsController>(() => CompletedTripsController());
        // Get.put<CompletedTipsController>(CompletedTipsController());
  }
}