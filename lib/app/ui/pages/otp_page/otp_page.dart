import 'package:cab_rider_its/app/customization/customization.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../../../controllers/controllers.dart';

class OtpPage extends GetView<OtpController> {
  const OtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  const VerticalAppSpacer(space: 120),
                  const AppName(),
                  const AppTagLine(),
                  const VerticalAppSpacer(space: 100),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OTP Code',
                          style: GoogleFonts.catamaran(
                            color: Colors.black45,
                            fontSize: 14,
                          ),
                        ),
                        const VerticalAppSpacer(),
                        TextField(
                          onChanged: controller.onOTPValueChanged,
                        ),
                        const VerticalAppSpacer(),
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
                                    onPressed: controller.verifyOTPCode,
                                    state: controller.buttonState.value,
                                    progressIndicator:
                                        const CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.green),
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
      ),
    );
  }
}
