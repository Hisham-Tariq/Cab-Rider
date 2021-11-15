import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

updateTheRiderResponse(bool response, String tripId) {
  FirebaseFirestore.instance
      .collection('inProcessingTrips')
      .doc(tripId)
      .collection('ridersResponse')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    "response": response,
  });
}

Future<int> differenceBetweenRequestTimeAndCurrent(tripId) async {
  var data = await FirebaseFirestore.instance
      .collection('inProcessingTrips')
      .doc(tripId)
      .collection('ridersResponse')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  Timestamp _requestTime = data['requestedAt'];
  DateTime dateTime1 = DateTime.parse(_requestTime.toDate().toString());
  DateTime dateTime2 = DateTime.now();
  return dateTime2
      .difference(dateTime1)
      .inSeconds; // or in whatever format you want.
}
