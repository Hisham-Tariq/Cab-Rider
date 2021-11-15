import 'package:cab_rider_its/app/controllers/controllers.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BalancePage extends GetView<BalanceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rs.',
                  style: GoogleFonts.catamaran(
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                    fontSize: 35.0,
                  ),
                ),
                Text(
                  ' ${Get.find<RiderController>().rider.balanceToPay}',
                  style: GoogleFonts.catamaran(
                    fontWeight: FontWeight.w900,
                    fontSize: 40.0,
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
