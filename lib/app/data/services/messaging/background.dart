import 'dart:async';

import '../../../controllers/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

handleRequestTheRiderAboutNewTripBG(RemoteMessage message) {}

handleNotificationWhenNeedDriverBG(RemoteMessage message) async {
  var controller = Get.put<RiderController>(RiderController());
  await controller.readCurrentUser();
  if (message.data['vehicle'] != controller.rider.vehicleType) return;
  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((value) {
    print(value.latitude);
    print(value.longitude);
    FirebaseFirestore.instance
        .collection('inProcessingTrips')
        .doc(message.data['id'])
        .collection('availableRiders')
        .doc(controller.rider.id)
        .set({
      'lat': value.latitude,
      'lng': value.longitude,
    });
  });
}

Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
  await Firebase.initializeApp();
  if (message.data.containsKey('funName') &&
      FirebaseAuth.instance.currentUser != null) {
    switch (message.data['funName']) {
      case 'notificationWhenNeedDriver':
        handleNotificationWhenNeedDriverBG(message);
        break;
      case 'requestTheRiderAboutNewTrip':
        handleRequestTheRiderAboutNewTripBG(message);
        break;
    }
  }
}
