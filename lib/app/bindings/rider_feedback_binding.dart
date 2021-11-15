
import 'package:get/get.dart';
import '../controllers/rider_feedback_controller.dart';


class RiderFeedbackBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiderFeedbackController>(() => RiderFeedbackController());
        // Get.put<RiderFeedbackController>(RiderFeedbackController());
  }
}