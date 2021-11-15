
import 'package:get/get.dart';
import '../controllers/balance_controller.dart';


class BalanceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BalanceController>(() => BalanceController());
        // Get.put<BalanceController>(BalanceController());
  }
}