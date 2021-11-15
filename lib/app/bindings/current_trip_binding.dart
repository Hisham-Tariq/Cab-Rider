
import 'package:get/get.dart';
import '../controllers/current_trip_controller.dart';


class CurrentTripBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrentTripController>(() => CurrentTripController());
        // Get.put<CurrentTripController>(CurrentTripController());
  }
}