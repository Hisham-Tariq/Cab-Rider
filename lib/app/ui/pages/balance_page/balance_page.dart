import 'package:cab_rider_its/app/ui/utils/utils.dart';

import '../../../controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/text_theme.dart';

class BalancePage extends GetView<BalanceController> {
  const BalancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rs.',
                style: AppTextStyle(
                  fontWeight: FontWeight.w900,
                  color: context.theme.colorScheme.primary,
                  fontSize: ResponsiveSize.height(20),
                ),
              ),
              Text(
                ' ${Get.find<RiderController>().rider.balanceToPay}',
                style: AppTextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: ResponsiveSize.height(30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
