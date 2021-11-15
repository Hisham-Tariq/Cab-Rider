import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import 'rider_controller.dart';

enum VehicleType { rickshaw, bike, car }

class RiderProffesionalInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final vehicleTypesValues = <VehicleType, String>{
    VehicleType.bike: 'Bike',
    VehicleType.car: 'Car',
    VehicleType.rickshaw: 'Rickshaw',
  };

  VehicleType? character = VehicleType.bike;
  final buttonState = ButtonState.idle.obs;

  final spaceBetweenFields = 16.0;
  final vehicleTypeFocusNode = FocusNode();

  VehicleType? selectedVehicleType;
  String? selectedVehicle;

  final vehicleTypeController = TextEditingController(text: 'Select');
  final licenseController = TextEditingController();
  final licenseNode = FocusNode();

  String get licenseNo => licenseController.text;

  changeToErrorState() async {
    buttonState.value = ButtonState.fail;
    await Future.delayed(const Duration(seconds: 2));
    changeToIdleState();
  }

  changeToLoadingState() => buttonState.value = ButtonState.loading;
  changeToIdleState() => buttonState.value = ButtonState.idle;
  changeToSuccessState() => buttonState.value = ButtonState.success;

  selectAVehicle(VehicleType type) {
    selectedVehicleType = type;
    vehicleTypeController.text = "${vehicleTypesValues[type]}";
    Get.back();
  }

  Future saveRiderToFirebase() async {
    if (!formKey.currentState!.validate()) return;
    changeToLoadingState();
    var controller = Get.find<RiderController>();
    controller.rider.licenseNo = licenseNo;
    controller.rider.vehicleType = vehicleTypesValues[selectedVehicleType];
    controller.rider.isApproved = false;
    var res = await controller.createRider();
    if (res) {
      changeToSuccessState();
      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed(AppRoutes.WAIT_FOR_APPROVAL);
    } else {
      changeToErrorState();
    }
  }
}