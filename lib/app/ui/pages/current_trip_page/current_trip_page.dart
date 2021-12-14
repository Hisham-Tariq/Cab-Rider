import 'package:animate_do/animate_do.dart';
import '../../../generated/assets.dart';
import '../../../models/models.dart';
import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

class CurrentTripPage extends GetView<CurrentTripController> {
  late final GoogleMapController _mapController;
  final _riderController = Get.find<RiderController>();

  CurrentTripPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _riderController.isRiderHaveCurrentTrip
            ? GetBuilder<CurrentTripController>(
                builder: (controller) {
                  if (controller.currentLocation != null && controller.trip != null) {
                    return Stack(
                      children: [
                        // Google Map
                        Positioned(
                          top: 250,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: controller.currentLocation as LatLng,
                              zoom: 15.0,
                            ),
                            polylines: {
                              if (controller.tripDirections != null)
                                Polyline(
                                  polylineId: const PolylineId('overview_polyline'),
                                  color: controller.trip!.tripStatus == TripStatus.pending ? Colors.red : Colors.green,
                                  width: 5,
                                  points: controller.tripDirections!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                                ),
                            },
                            markers: [
                              if (controller.trip!.tripStatus == TripStatus.pending)
                                Marker(
                                  markerId: MarkerId('PickUp'),
                                  position: controller.trip!.userPickupLocation,
                                ),
                              if (controller.trip!.tripStatus == TripStatus.started)
                                Marker(
                                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                                  markerId: MarkerId('Destination'),
                                  position: controller.trip!.userDestinationLocation,
                                ),
                            ].toSet(),
                            onMapCreated: (controller) => _mapController = controller,
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                          ),
                        ),
                        // InfoBox
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: buildInfoPanel(),
                        ),
                      ],
                    );
                  } else {
                    return SpinKitFadingCircle(
                      color: context.theme.colorScheme.primary,
                    );
                  }
                },
              )
            : Container(
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
                          "Don't have any schedule trips",
                          style: AppTextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Container buildInfoPanel() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, 3),
            spreadRadius: 2.0,
            blurRadius: 15.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 8.0),
                width: double.infinity,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Current Trip',
                        style: AppTextStyle(
                          fontSize: 24.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TitleDetail(
                      title: 'Customer Name',
                      detail: GetUtils.capitalizeFirst(controller.trip!.userName) as String,
                    ),
                    VerticalSpacer(),
                    TitleDetail(
                      title: 'Customer Contact',
                      detail: controller.trip!.userPhone,
                    ),
                    VerticalSpacer(),
                    TitleDetail(
                      title: 'Trip Status',
                      detail: GetUtils.capitalizeFirst(controller.trip!.tripStatus) as String,
                    ),
                    VerticalSpacer(space: 16.0),
                    Row(
                      children: [
                        _LegendDetail(
                          icon: Icons.location_on,
                          iconColor: Colors.red,
                          title: 'Customer Location',
                        ),
                        _LegendDetail(
                          icon: Icons.location_on,
                          iconColor: Colors.green,
                          title: 'Customer Destination',
                        ),
                      ],
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            if (controller.trip!.tripStatus == TripStatus.pending)
              FadeIn(
                child: Container(
                  height: 55,
                  child: OutlinedButton(
                    onPressed: controller.onStartTrip,
                    child: const Text('Start'),
                  ),
                ),
              ),
            if (controller.trip!.tripStatus == TripStatus.started)
              FadeIn(
                child: SizedBox(
                  height: 55,
                  child: OutlinedButton(
                    onPressed: controller.onEndTrip,
                    child: const Text('End'),
                    style: OutlinedButton.styleFrom(
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendDetail extends StatelessWidget {
  const _LegendDetail({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            HorizontalSpacer(),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class TitleDetail extends StatelessWidget {
  const TitleDetail({Key? key, required this.title, required this.detail}) : super(key: key);

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
              fontSize: 18,
              color: Colors.green,
            ),
          ),
          TextSpan(
            text: detail,
            style: AppTextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
