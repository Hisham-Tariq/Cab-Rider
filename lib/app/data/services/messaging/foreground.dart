import '../../../controllers/controllers.dart';
import '../../../generated/assets.dart';
import '../../../ui/global_widgets/global_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'common.dart';

handleNotificationWhenNeedDriver(RemoteMessage message) {
  var controller = Get.find<RiderController>();
  if (message.data['vehicle'] != controller.rider.vehicleType) return;
  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
    print(value.latitude);
    print(value.longitude);
    FirebaseFirestore.instance.collection('inProcessingTrips').doc(message.data['id']).collection('availableRiders').doc(controller.rider.id).set({
      'lat': value.latitude,
      'lng': value.longitude,
    });
  });
}

handleRequestTheRiderAboutNewTrip(RemoteMessage message) async {
  var tripId = message.data['tripId'];
  int timePassed = await differenceBetweenRequestTimeAndCurrent(tripId);
  print('Time Passed: $timePassed');
  Dialogs.materialDialog(
      barrierDismissible: false,
      msg: message.notification!.body,
      title: "Need Rider?",
      color: Colors.white,
      lottieBuilder: Lottie.asset(
        Assets.animCar,
        fit: BoxFit.contain,
      ),
      context: Get.context as BuildContext,
      actions: [
        TextButton(
          onPressed: () {
            updateTheRiderResponse(true, message.data['tripId']);
            navigator!.pop();
          },
          child: const Text('Accept'),
        ),
        TimerButton(
          backgroundColor: Colors.red.withOpacity(0.0),
          textColor: Colors.red,
          borderColor: Colors.red,
          splashColor: Colors.red.shade800,
          time: int.parse(message.data['timeout']) - timePassed,
          onTap: () {
            updateTheRiderResponse(false, tripId);
            navigator!.pop();
          },
        ),
      ]);
}

firebaseForegroundMessage(RemoteMessage message) {
  if (message.notification != null) print(message.notification!.body);
  if (message.data.containsKey('funName') && FirebaseAuth.instance.currentUser != null) {
    switch (message.data['funName']) {
      case 'notificationWhenNeedDriver':
        handleNotificationWhenNeedDriver(message);
        break;
      case 'requestTheRiderAboutNewTrip':
        handleRequestTheRiderAboutNewTrip(message);
        break;
    }
  }
}
