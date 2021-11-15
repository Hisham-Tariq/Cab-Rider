import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/controllers.dart';

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
              style: GoogleFonts.catamaran(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const VerticalAppSpacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Visit the CAB office and approve your account to continue',
                textAlign: TextAlign.center,
                style: GoogleFonts.catamaran(
                  color: Colors.black45,
                  fontSize: 14.0,
                ),
              ),
            ),
            const VerticalAppSpacer(space: 24.0),
            FullTextButton(
              onPressed: () {
                Get.find<RiderController>().signOutRider().then((isSuccessful) {
                  if (isSuccessful) Get.offAllNamed(AppRoutes.INTRODUCTION);
                });
              },
              text: 'Sign Out',
            ),
            const VerticalAppSpacer(space: 12.0),
            FullOutlinedTextButton(
              onPressed: controller.checkRiderApproval,
              text: 'Recheck',
            )
          ],
        ),
      ),
    );
  }
}
