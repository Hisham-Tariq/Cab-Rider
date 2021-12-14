
import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'rider_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneInputController extends GetxController {
  PhoneInputController({this.isNewUser = true});
  final bool isNewUser;

  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  final buttonState = ButtonState.idle.obs;
  final RiderController _userController = Get.find<RiderController>();

  String? validatePhone(String? value) {
    if (value!.isEmpty) {
      return 'Must provide the phone number';
    } else if (value.length != 11) {
      return 'Invalid Phone Number';
    }
    return null;
  }

  changeToErrorState() async {
    buttonState.value = ButtonState.fail;
    await Future.delayed(const Duration(seconds: 2));
    changeToIdleState();
  }

  changeToLoadingState() => buttonState.value = ButtonState.loading;
  changeToIdleState() => buttonState.value = ButtonState.idle;
  changeToSuccessState() => buttonState.value = ButtonState.success;

  String get formatedPhoneNumber  {
    return '+92${phoneController.text.replaceFirst("0", "")}';
  }

  Future<bool> checkUserExistenceInFirebase() async {
    var phoneNumber = formatedPhoneNumber;
    var isExist = await _userController
        .riderWithPhoneNumberIsExistInFirestore(phoneNumber);
    if (isNewUser && isExist) {
      Fluttertoast.showToast(msg: "Rider already exist, Try to Login");
      changeToErrorState();
      return false;
    } else if (!isNewUser && !isExist) {
      Fluttertoast.showToast(
          msg: "Rider doesn't exist, please get yourself register");
      changeToErrorState();
      return false;
    }
    return true;
  }

  onOTPCodeSent(String verificationId, int? forceResendingToken) {
    changeToSuccessState();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      var arguments = {
        "isNewUser": isNewUser,
        "verificationId": verificationId,
        "forceResendingToken": forceResendingToken,
      };
      Get.toNamed(AppRoutes.OTP, arguments: arguments);
    });
  }

  onVerificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
    changeToSuccessState();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (isNewUser) {
        Get.toNamed(AppRoutes.RIDER_PERSONAL_INFO);
      } else {
        _userController.readCurrentUser().then((_) {
          if (_userController.rider.isApproved as bool) {
            Get.offAllNamed(AppRoutes.HOME);
          } else {
            Get.offAllNamed(AppRoutes.WAIT_FOR_APPROVAL);
          }
        });
      }
    });
  }

  onVerificationFailed(FirebaseAuthException error) {
    changeToErrorState();
    if (error.code == 'invalid-phone-number') {
      Fluttertoast.showToast(msg: "Invalid Phone Number");
    } else {
      Fluttertoast.showToast(msg: "Verification Failed");
    }
  }

  Future<void> verifyPhoneNumber() async {
    phoneFocusNode.unfocus();
    if (!formKey.currentState!.validate()) return;
    changeToLoadingState();

    FirebaseAuth auth = FirebaseAuth.instance;
    if (!(await checkUserExistenceInFirebase())) return;

    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: formatedPhoneNumber,
      verificationCompleted: onVerificationCompleted,
      codeSent: onOTPCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: onVerificationFailed,
    );
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Must provide the phone number';
    } else if (value.length != 11) {
      return 'Invalid Phone Number';
    }
    return null;
  }
}