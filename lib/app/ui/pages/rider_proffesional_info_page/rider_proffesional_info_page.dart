import 'package:cab_rider_its/app/ui/utils/utils.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

class RiderProffesionalInfoPage extends GetView<RiderProffesionalInfoController> {
  const RiderProffesionalInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: SafeArea(
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ListView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      children: [
                        const VerticalSpacer(space: 20),
                        const AppName(),
                        const VerticalSpacer(),
                        Center(
                          child: Text(
                            'Professional Information',
                            style: AppTextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Complete your detail to continue providing others peaceful rides',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: AppTextStyle(
                              color: Colors.grey,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        const VerticalSpacer(space: 12),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                readOnly: true,
                                focusNode: controller.vehicleTypeFocusNode,
                                controller: controller.vehicleTypeController,
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
                                    const VehicleSelectionSheet(),
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
                              VerticalSpacer(space: controller.spaceBetweenFields),
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
                              VerticalSpacer(space: controller.spaceBetweenFields),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => ProgressButton.icon(
                                        textStyle: AppTextStyle(
                                          color: context.theme.colorScheme.onPrimary,
                                        ),
                                        iconedButtons: {
                                          ButtonState.idle: IconedButton(
                                            text: "Verify",
                                            icon: Icon(
                                              Icons.arrow_forward,
                                              color: context.theme.colorScheme.onPrimary,
                                            ),
                                            color: context.theme.colorScheme.primary,
                                          ),
                                          ButtonState.loading: IconedButton(
                                            text: "Loading",
                                            color: context.theme.colorScheme.primary,
                                          ),
                                          ButtonState.fail: IconedButton(
                                            text: "Failed",
                                            icon: Icon(
                                              Icons.cancel,
                                              color: context.theme.colorScheme.onError,
                                            ),
                                            color: context.theme.colorScheme.error,
                                          ),
                                          ButtonState.success: IconedButton(
                                            text: "Success",
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: context.theme.colorScheme.onPrimary,
                                            ),
                                            color: context.theme.colorScheme.primary,
                                          )
                                        },
                                        onPressed: controller.saveRiderToFirebase,
                                        state: controller.buttonState.value,
                                        progressIndicator: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation(context.theme.colorScheme.primary),
                                        ),
                                      ),
                                    ),
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
                Positioned(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: context.theme.colorScheme.onSurface,
                    ),
                    onPressed: Get.back,
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
      height: ResponsiveSize.height(130),
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      width: double.infinity,
      color: context.theme.colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Chose vehicle type',
              style: AppTextStyle(
                fontSize: ResponsiveSize.height(10),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const VerticalSpacer(space: 8.0),
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
        const VerticalSpacer(),
        VehicleTile(
          title: 'Rickshaw',
          vehicleSvgPath: 'assets/svg/rickshaw.svg',
          onTap: () => controller.selectAVehicle(VehicleType.rickshaw),
        ),
        const VerticalSpacer(),
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
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            offset: Offset.zero,
            blurRadius: 2.0,
            blurStyle: BlurStyle.inner,
            spreadRadius: 0.5,
            color: context.theme.colorScheme.inverseSurface,
          ),
        ],
      ),
      child: Material(
        child: ListTile(
          // contentPadding: EdgeInsets.zero,
          minVerticalPadding: 24.0,
          tileColor: context.theme.colorScheme.surfaceVariant,
          leading: Container(
            height: double.infinity,
            width: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SvgPicture.asset(
              vehicleSvgPath,
              height: 20,
            ),
          ),
          title: Text(
            title,
            style: AppTextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
