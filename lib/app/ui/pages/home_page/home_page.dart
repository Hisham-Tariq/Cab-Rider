import 'package:cab_rider_its/app/generated/assets.dart';
import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/controllers.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        title: Text(
          'Home',
          style: GoogleFonts.catamaran(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            _RiderStatusSwitch(),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        DashboardTile(
                          title: 'Completed Trips',
                          svg: Assets.dashboardCompleted,
                          onTap: () {
                            Get.toNamed(AppRoutes.COMPLETED_TIPS);
                          },
                        ),
                        HorizontalAppSpacer(space: 16.0),
                        DashboardTile(
                          onTap: () {
                            Get.toNamed(AppRoutes.CURRENT_TRIP);
                          },
                          title: 'Current Trips',
                          svg: Assets.dashboardPending,
                        ),
                      ],
                    ),
                    VerticalAppSpacer(),
                    Row(
                      children: [
                        DashboardTile(
                          onTap: () {
                            Get.toNamed(AppRoutes.BALANCE);
                          },
                          title: 'Balance',
                          svg: Assets.dashboardWallet,
                        ),
                        HorizontalAppSpacer(space: 16.0),
                        DashboardTile(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAllNamed(AppRoutes.SPLASH);
                          },
                          title: 'Sign Out',
                          svg: Assets.dashboardLogout,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _RiderStatusSwitch extends StatefulWidget {
  const _RiderStatusSwitch({Key? key}) : super(key: key);

  @override
  _RiderStatusSwitchState createState() => _RiderStatusSwitchState();
}

class _RiderStatusSwitchState extends State<_RiderStatusSwitch> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiderController>(
      builder: (logic) {
        return SwitchListTile(
          value: logic.rider.riderStatus as bool,
          title: const Text(
            'Rider Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onChanged: (value) {
            logic.changeRiderStatus(value);
          },
        );
      },
    );
  }
}

class DashboardTile extends StatelessWidget {
  const DashboardTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.svg,
  }) : super(key: key);

  final Callback onTap;
  final String title;
  final String svg;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                svg,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
              Text(
                title,
                style: GoogleFonts.catamaran(
                  fontSize: 15.0,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 5.0,
                spreadRadius: 5.0,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
