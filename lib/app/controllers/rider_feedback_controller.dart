import 'package:cab_rider_its/app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RiderFeedbackController extends GetxController {
  int rideRating = 3;
  int appRating = 3;
  var comment = TextEditingController();
  closeRating() => Get.offAllNamed(AppRoutes.HOME);
  updateRiderRating(double rating) => rideRating = rating.toInt();
  updateAppRating(double rating) => appRating = rating.toInt();
  submitRating() async {
    await FirebaseFirestore.instance
        .collection('BookedTrips')
        .doc(Get.arguments['bookingId'])
        .collection('feedback')
        .doc('rider')
        .set({
      'appRating': appRating,
      'rideRating': rideRating,
      'comment': comment.text,
      'filledAt': FieldValue.serverTimestamp(),
    });
    Get.offAllNamed(AppRoutes.HOME);
  }
}
