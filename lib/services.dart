import 'package:cloud_firestore/cloud_firestore.dart';

class Services {
  var inProcessingTripsRef = FirebaseFirestore.instance.collection('needRider');
  var availableRidersForTripRef =
      FirebaseFirestore.instance.collection('availableRiders');

  void checkIfSomeOneNeedRider() {
    inProcessingTripsRef.snapshots().listen((event) {
      inProcessingTripsRef
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get()
          .then((value) {
        updateLocationToFirebase(value.docs.first);
      });
    });
  }

  updateLocationToFirebase(DocumentSnapshot doc) {
    availableRidersForTripRef.doc(doc.id).set({
      'riders': [1, 2, 3]
    });
    // FirebaseFirestore.instance.runTransaction((transaction) async {
    //   var freshShot = await transaction.get(doc.reference);
    //   var list = List.from(freshShot['data']);
    //   list.add(list.last + 2);
    //   transaction.update(freshShot.reference, {
    //     "data": list,
    //   });
    // });
    // availableRidersForTripRef.doc(doc.id).
  }
}
