
import 'package:get/get.dart';
import '../controllers/wait_for_approval_controller.dart';


class WaitForApprovalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitForApprovalController>(() => WaitForApprovalController());
        // Get.put<WaitForApprovalController>(WaitForApprovalController());
  }
}