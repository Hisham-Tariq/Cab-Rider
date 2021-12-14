import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/booked_trip_model/booked_trip_model.dart';
import '../models/models.dart';
import 'rider_controller.dart';

class CompletedTripsController extends GetxController {
  List<BookedTripModel> completedTrips = [];

  @override
  void onInit() {
    super.onInit();
    _readRidersCompleteTrips();
  }

  _readRidersCompleteTrips() {
    var rid = Get.find<RiderController>().currentRiderUID;
    FirebaseFirestore.instance
        .collection('BookedTrips')
        .where('tripStatus', isEqualTo: TripStatus.ended)
        .where('riderId', isEqualTo: rid)
        .get()
        .then((value) {

      completedTrips.clear();
      for (var element in value.docs) {
        completedTrips.add(BookedTripModel.fromDocument(element));
      }
      update();
    });
  }
}
