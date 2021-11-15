import 'package:cab_rider_its/app/customization/customization.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../../../controllers/controllers.dart';

class RiderProffesionalInfoPage extends GetView<RiderProffesionalInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Professional Information',
                  style: GoogleFonts.catamaran(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Complete your detail to continue providing others peaceful rides',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.catamaran(
                      color: Colors.grey,
                      fontSize: 13.0,
                    ),
                  ),
                ),
                const VerticalAppSpacer(space: 40),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        readOnly: true,
                        focusNode: controller.vehicleTypeFocusNode,
                        controller: controller.vehicleTypeController,
                        style: AppTextStyle.textField,
                        validator: (_) {
                          if (controller.selectedVehicleType == null) {
                            return 'Invalid Vehicle';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Vehicle Type',
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(200.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        onTap: () {
                          controller.vehicleTypeFocusNode.unfocus();
                          Get.bottomSheet(
                            VehicleSelectionSheet(),
                            ignoreSafeArea: true,
                            isDismissible: false,
                            persistent: true,
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(200, 40),
                                topRight: Radius.elliptical(200, 40),
                              ),
                            ),
                          );
                        },
                      ),
                      VerticalAppSpacer(space: controller.spaceBetweenFields),
                      TextFormField(
                        controller: controller.licenseController,
                        focusNode: controller.licenseNode,
                        validator: (value) {
                          if (value!.isEmpty) return 'Invalid License';
                        },
                        decoration: const InputDecoration(
                          labelText: 'Driver License',
                        ),
                      ),
                      VerticalAppSpacer(space: controller.spaceBetweenFields),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Obx(() => ProgressButton.icon(
                                  iconedButtons: const {
                                    ButtonState.idle: IconedButton(
                                      text: "Verify",
                                      icon: Icon(Icons.arrow_forward,
                                          color: Colors.white),
                                      color: AppColors.primary,
                                    ),
                                    ButtonState.loading: IconedButton(
                                      text: "Loading",
                                      color: AppColors.primary,
                                    ),
                                    ButtonState.fail: IconedButton(
                                      text: "Failed",
                                      icon: Icon(Icons.cancel,
                                          color: Colors.white),
                                      color: AppColors.error,
                                    ),
                                    ButtonState.success: IconedButton(
                                      text: "Success",
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      color: AppColors.primary,
                                    )
                                  },
                                  onPressed: controller.saveRiderToFirebase,
                                  state: controller.buttonState.value,
                                  progressIndicator: CircularProgressIndicator(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.0),
                                    valueColor: const AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class VehicleSelectionSheet extends GetView<RiderProffesionalInfoController> {
  const VehicleSelectionSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (controller.selectedVehicleType != null)
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                  onTap: () {
                    controller.selectedVehicleType = null;
                  },
                ),
              Expanded(
                child: Center(
                  child: Text(
                    'Chose vehicle type',
                    style: AppTextStyle.primaryHeading,
                  ),
                ),
              ),
            ],
          ),
          const VerticalAppSpacer(space: 24.0),
          _vehicleTypeSelectionWidget(),
        ],
      ),
    );
  }

  _vehicleTypeSelectionWidget() {
    return Column(
      children: [
        VehicleTile(
          title: 'Bike',
          vehicleSvgPath: 'assets/svg/bike.svg',
          onTap: () => controller.selectAVehicle(VehicleType.bike),
        ),
        const VerticalAppSpacer(space: 16.0),
        VehicleTile(
          title: 'Rickshaw',
          vehicleSvgPath: 'assets/svg/rickshaw.svg',
          onTap: () => controller.selectAVehicle(VehicleType.rickshaw),
        ),
        const VerticalAppSpacer(space: 16.0),
        VehicleTile(
          title: 'Car',
          vehicleSvgPath: 'assets/svg/car.svg',
          onTap: () => controller.selectAVehicle(VehicleType.car),
        ),
      ],
    );
  }
}

class VehicleTile extends StatelessWidget {
  const VehicleTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.vehicleSvgPath,
  }) : super(key: key);

  final String title;
  final Callback onTap;
  final String vehicleSvgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          tileColor: Colors.grey.shade100,
          leading: Container(
            height: double.infinity,
            width: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(
              vehicleSvgPath,
              height: 20,
            ),
          ),
          title: Text(title),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
