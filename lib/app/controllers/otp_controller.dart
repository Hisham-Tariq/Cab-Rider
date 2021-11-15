import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';

import 'rider_controller.dart';

class OtpController extends GetxController {
  // late final String verificationId;
  // late final int? forceResendingToken;
  // late final bool isNewUser;
  final formKey = GlobalKey<FormState>();
  String otpCode = '';
  final buttonState = ButtonState.idle.obs;

  // OTPController() {
  //   // verificationId = Get.arguments['verificationId'];
  //   // isNewUser = Get.arguments['isNewUser'];
  //   // isNewUser.printInfo();
  //   // forceResendingToken = Get.arguments['forceResendingToken'];
  // }

  String get verificationId => Get.arguments['verificationId'];
  int? get forceResendingToken => Get.arguments['forceResendingToken'];
  bool get isNewUser => Get.arguments['isNewUser'];

  changeToErrorState() async {
    buttonState.value = ButtonState.fail;
    await Future.delayed(const Duration(seconds: 2));
    changeToIdleState();
  }

  changeToLoadingState() => buttonState.value = ButtonState.loading;
  changeToIdleState() => buttonState.value = ButtonState.idle;
  changeToSuccessState() => buttonState.value = ButtonState.success;

  onOTPValueChanged(String value) async {
    otpCode = value;
    if (value.length == 6) {
      FocusScope.of(Get.context!).unfocus();
      await Future.delayed(const Duration(milliseconds: 10));
      verifyOTPCode();
    }
  }

  Future<void> verifyOTPCode() async {
    // if (!_formKey.currentState!.validate()) return;
    changeToLoadingState();
    // var otpCode = otpController.text;
    FocusScope.of(Get.context!).unfocus();
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: Get.arguments['verificationId'] as String,
      smsCode: otpCode,
    );

    try {
      await auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: "Signed in Successfully");
      changeToSuccessState();
      await Future.delayed(const Duration(seconds: 1));
      afterSuccessfullyAuthenticated();
    } catch (e) {
      if (auth.currentUser != null) {
        afterSuccessfullyAuthenticated();
      } else {
        changeToErrorState();
      }
    }
  }

  afterSuccessfullyAuthenticated() {
    var controller = Get.find<RiderController>();
    controller.rider.phoneNumber =
        FirebaseAuth.instance.currentUser!.phoneNumber;
    if (isNewUser) {
      Get.offAllNamed(AppRoutes.RIDER_PERSONAL_INFO);
    } else {
      controller.readCurrentUser().then((_) {
        if (controller.rider.isApproved as bool) {
          Get.offAllNamed(AppRoutes.HOME);
        } else {
          Get.offAllNamed(AppRoutes.WAIT_FOR_APPROVAL);
        }
      });
    }
  }
}
