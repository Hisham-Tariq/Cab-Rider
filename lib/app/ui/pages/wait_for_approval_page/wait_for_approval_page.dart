import 'package:cab_rider_its/app/ui/utils/utils.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

class WaitForApprovalPage extends GetView<WaitForApprovalController> {
  const WaitForApprovalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Not approved yet?',
              style: AppTextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const VerticalSpacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Visit the CAB office and approve your account to continue',
                textAlign: TextAlign.center,
                style: AppTextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            const VerticalSpacer(space: 24.0),
            TextButton(
              onPressed: () {
                Get.find<RiderController>().signOutRider().then((isSuccessful) {
                  if (isSuccessful) Get.offAllNamed(AppRoutes.INTRODUCTION);
                });
              },
              child: const Text('Sign Out'),
              style: TextButton.styleFrom(
                minimumSize: Size(ResponsiveSize.width(100), 50),
              ),
            ),
            const VerticalSpacer(),
            OutlinedButton(
              onPressed: controller.checkRiderApproval,
              child: const Text('Recheck'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(ResponsiveSize.width(100), 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
