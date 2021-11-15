
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
class RiderPersonalInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final firstNameNode = FocusNode();

  final lastNameController = TextEditingController();
  final lastNameNode = FocusNode();

  final emailController = TextEditingController();
  final emailNode = FocusNode();

  final cnicController = TextEditingController();
  final cnicNode = FocusNode();

  final spaceBetweenFields = 16.0;

  String? get firstName => GetUtils.capitalizeFirst(firstNameController.text);
  get lastName => GetUtils.capitalizeFirst(lastNameController.text);
  get email => emailController.text;
  get cnic => cnicController.text;

  unFocusFields() {
    firstNameNode.unfocus();
    lastNameNode.unfocus();
    emailNode.unfocus();
  }
}