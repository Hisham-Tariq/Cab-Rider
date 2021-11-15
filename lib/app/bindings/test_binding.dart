
import 'package:get/get.dart';
import '../controllers/test_controller.dart';


class TestBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestController>(() => TestController());
        // Get.put<TestController>(TestController());
  }
}