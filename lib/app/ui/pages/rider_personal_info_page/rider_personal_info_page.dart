import '../../../routes/app_routes.dart';
import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

class RiderPersonalInfoPage extends GetView<RiderPersonalInfoController> {
  const RiderPersonalInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                const VerticalSpacer(space: 20),
                const AppName(),
                const VerticalSpacer(),
                Center(
                  child: Text(
                    'Personal Information',
                    style: AppTextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      //First Name
                      TextFormField(
                        autofocus: true,
                        controller: controller.firstNameController,
                        focusNode: controller.firstNameNode,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid First Name' : null;
                        },
                      ),
                      const VerticalSpacer(),
                      // Last Name
                      TextFormField(
                        controller: controller.lastNameController,
                        focusNode: controller.lastNameNode,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Last Name' : null;
                        },
                      ),
                      const VerticalSpacer(),
                      TextFormField(
                        focusNode: controller.emailNode,
                        controller: controller.emailController,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (!GetUtils.isEmail(value)) {
                              return 'Invalid Email';
                            }
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Email(Optional)'),
                      ),
                      const VerticalSpacer(),
                      TextFormField(
                        controller: controller.cnicController,
                        focusNode: controller.cnicNode,
                        validator: (value) => value!.isEmpty ? 'Invalid CNIC' : null,
                        decoration: const InputDecoration(labelText: 'CNIC'),
                      ),
                      const VerticalSpacer(space: 12.0),
                      TextButton(
                        child: const Text('Continue'),
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
                      // VerticalSpacer(space: controller.spaceBetweenFields * 2),
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
