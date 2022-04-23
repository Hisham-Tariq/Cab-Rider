import 'package:cab_rider_its/app/data/models/booked_trip_model/booked_trip_model.dart';
import 'package:intl/intl.dart';

import '../../../generated/assets.dart';
import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';
import '../../utils/utils.dart';

class CompletedTripsPage extends GetView<CompletedTripsController> {
  const CompletedTripsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CompletedTripsController>(builder: (controller) {
          if (controller.completedTrips.isEmpty) {
            return const _ZeroCompletedTrips();
          } else {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50.0),
                  height: Get.height,
                  child: ListView.builder(
                    itemCount: controller.completedTrips.length,
                    itemBuilder: (context, index) {
                      return _CompletedTripCard(trip: controller.completedTrips[index]);
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 10,
                  child: Center(
                    child: Text(
                      'Completed Trips',
                      style: AppTextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class _CompletedTripCard extends StatelessWidget {
  const _CompletedTripCard({Key? key, required this.trip}) : super(key: key);
  final BookedTripModel trip;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Card(
        child: Container(
          // height: 232,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpacer(),
              _TitleDetail(
                title: 'Customer Name',
                detail: GetUtils.capitalize(trip.userName) as String,
              ),
              const VerticalSpacer(),
              _TitleDetail(
                title: 'Booked At',
                detail: DateFormat.yMd().add_jm().format(DateTime.parse(trip.bookedAt)),
              ),
              const VerticalSpacer(),
              _TitleDetail(
                title: 'Completed At',
                detail: trip.completedAt != null ? DateFormat.yMd().add_jm().format(DateTime.parse(trip.completedAt!)) : "Not Yet",
              ),
              const VerticalSpacer(),
              _TitleDetail(
                title: 'Price',
                detail: trip.tripPrice.toString(),
              ),
              const VerticalSpacer(),
              _TitleDetail(
                title: 'Distance',
                detail: '${trip.tripDistance} KM',
              ),
              const VerticalSpacer(),
              // OutlinedButton(
              //   onPressed: () {},
              //   text: 'Detail',
              //   backgroundColor: Colors.grey.withOpacity(0.0),
              // ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
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
                style: AppTextStyle(
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
  const _TitleDetail({Key? key, required this.title, required this.detail}) : super(key: key);

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: AppTextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: context.theme.colorScheme.tertiary,
            ),
          ),
          TextSpan(
            text: detail,
            style: AppTextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
