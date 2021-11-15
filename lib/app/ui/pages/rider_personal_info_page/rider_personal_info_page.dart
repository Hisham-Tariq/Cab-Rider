import 'package:cab_rider_its/app/customization/customization.dart';
import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/controllers.dart';

class RiderPersonalInfoPage extends GetView<RiderPersonalInfoController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                const VerticalAppSpacer(space: 50),
                Text(
                  'Personal Information',
                  style: GoogleFonts.catamaran(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                const VerticalAppSpacer(space: 50),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      //First Name
                      TextFormField(
                        autofocus: true,
                        controller: controller.firstNameController,
                        focusNode: controller.firstNameNode,
                        style: AppTextStyle.textField,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid First Name' : null;
                        },
                      ),
                      VerticalAppSpacer(space: controller.spaceBetweenFields),
                      // Last Name
                      TextFormField(
                        controller: controller.lastNameController,
                        focusNode: controller.lastNameNode,
                        style: AppTextStyle.textField,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Last Name' : null;
                        },
                      ),
                      VerticalAppSpacer(space: controller.spaceBetweenFields),
                      // Email
                      TextFormField(
                        focusNode: controller.emailNode,
                        controller: controller.emailController,
                        style: AppTextStyle.textField,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (!GetUtils.isEmail(value)) {
                              return 'Invalid Email';
                            }
                          }
                        },
                        decoration:
                            const InputDecoration(labelText: 'Email(Optional)'),
                      ),
                      VerticalAppSpacer(space: controller.spaceBetweenFields),
                      // CNIC
                      TextFormField(
                        controller: controller.cnicController,
                        focusNode: controller.cnicNode,
                        style: AppTextStyle.textField,
                        validator: (value) =>
                            value!.isEmpty ? 'Invalid CNIC' : null,
                        decoration: const InputDecoration(labelText: 'CNIC'),
                      ),
                      VerticalAppSpacer(space: controller.spaceBetweenFields * 2),
                      FullTextButton(
                        text: 'Continue',
                        onPressed: () {
                          controller.unFocusFields();
                          if (controller.formKey.currentState!.validate()) {
                            var userController = Get.find<RiderController>();
                            userController.rider.firstName = controller.firstName;
                            userController.rider.lastName = controller.lastName;
                            userController.rider.email = controller.email;
                            userController.rider.cnic = controller.cnic;
                            Get.toNamed(AppRoutes.RIDER_PROFFESIONAL_INFO);
                          }
                        },
                      ),
                      VerticalAppSpacer(space: controller.spaceBetweenFields * 2),
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
