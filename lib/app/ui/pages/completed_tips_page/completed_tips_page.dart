import 'package:cab_rider_its/app/customization/customization.dart';
import 'package:cab_rider_its/app/generated/assets.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/controllers.dart';

class CompletedTripsPage extends GetView<CompletedTripsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: GetBuilder<CompletedTripsController>(builder: (controller) {
          if (controller.completedTrips == null)
            return SpinKitFadingCircle(color: AppColors.primary);
          else if (controller.completedTrips!.length > 0)
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50.0),
                  color: Colors.grey.shade200,
                  height: Get.height,
                  child: _ListOfCompletedTrips(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 10,
                  child: Center(
                    child: Text(
                      'Completed Trips',
                      style: GoogleFonts.catamaran(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          else
            return _ZeroCompletedTrips();
        }),
      ),
    );
  }
}

class _ListOfCompletedTrips extends StatelessWidget {
  const _ListOfCompletedTrips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Get.find<CompletedTripsController>().completedTrips!.length,
      itemBuilder: (context, index) {
        return _CompletedTripCard(tripIndex: index);
      },
    );
  }
}

class _CompletedTripCard extends StatelessWidget {
  const _CompletedTripCard({Key? key, required this.tripIndex})
      : super(key: key);
  final int tripIndex;
  @override
  Widget build(BuildContext context) {
    var trip = Get.find<CompletedTripsController>().completedTrips![tripIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Container(
        height: 232,
        width: Get.width,
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleDetail(
              title: 'Customer Name',
              detail: GetUtils.capitalize(trip.userName) as String,
            ),
            VerticalAppSpacer(),
            _TitleDetail(
              title: 'Booked At',
              detail: trip.bookedAt!.toDate().toString(),
            ),
            VerticalAppSpacer(),
            _TitleDetail(
              title: 'Completed At',
              detail: trip.completedAt!.toDate().toString(),
            ),
            VerticalAppSpacer(),
            _TitleDetail(
              title: 'Price',
              detail: trip.tripPrice.toString(),
            ),
            VerticalAppSpacer(),
            _TitleDetail(
              title: 'Distance',
              detail: '${trip.tripDistance} KM',
            ),
            VerticalAppSpacer(space: 16.0),
            // FullOutlinedTextButton(
            //   onPressed: () {},
            //   text: 'Detail',
            //   backgroundColor: Colors.grey.withOpacity(0.0),
            // ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, 2),
                blurRadius: 8.0,
                spreadRadius: 8.0,
              ),
            ]),
      ),
    );
  }
}

class _ZeroCompletedTrips extends StatelessWidget {
  const _ZeroCompletedTrips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
      child: Stack(
        children: [
          SvgPicture.asset(
            Assets.dashboardNoData,
            fit: BoxFit.contain,
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'No trips completed yet',
                style: GoogleFonts.catamaran(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleDetail extends StatelessWidget {
  const _TitleDetail({Key? key, required this.title, required this.detail})
      : super(key: key);

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: GoogleFonts.catamaran(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          TextSpan(
            text: detail,
            style: GoogleFonts.catamaran(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
