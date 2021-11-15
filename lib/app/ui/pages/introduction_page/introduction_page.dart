import 'package:cab_rider_its/app/customization/customization.dart';
import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';

class IntroductionPage extends GetView<IntroductionController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Center(
            child: Column(
              children: [
                const VerticalAppSpacer(space: 120),
                const AppName(),
                const AppTagLine(),
                const VerticalAppSpacer(space: 100),
                // SignIn Button
                FullTextButton(
                  onPressed: () => Get.toNamed(AppRoutes.LOGIN),
                  text: 'Login',
                ),
                // SignUp Button
                const VerticalAppSpacer(),
                // Register Button
                FullOutlinedTextButton(
                  onPressed: () => Get.toNamed(AppRoutes.SIGNUP),
                  text: 'Register',
                ),
                const VerticalAppSpacer(),
                const _PrivacyPolicy(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _PrivacyPolicy extends StatelessWidget {
  const _PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'By choosing one or the other, you are agreeing to the',
          style: AppTextStyle.description,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Text(
                'Terms of services',
                style: AppTextStyle.emphasisDescription,
              ),
            ),
            Text(
              ' & ',
              style: AppTextStyle.description,
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Privacy policy',
                style: AppTextStyle.emphasisDescription,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

