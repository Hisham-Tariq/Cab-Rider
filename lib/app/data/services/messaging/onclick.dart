import '../../../generated/assets.dart';
import '../../../ui/global_widgets/global_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'common.dart';

handleRequestTheRiderAboutNewTripOnClick(RemoteMessage message) async {
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
          child: Text('Accept'),
        ),
        TimerButton(
          backgroundColor: Colors.red.withOpacity(0.0),
          textColor: Colors.red,
          borderColor: Colors.red,
          splashColor: Colors.red.shade800,
          time: int.parse(message.data['timeout']) - timePassed,
          onTap: () {
            updateTheRiderResponse(false, message.data['tripId']);
            navigator!.pop();
          },
        ),
      ]);
}

firebaseOnMessageClicked(message) {
  print('Message Clicked');
  if (message.data.containsKey('funName') && FirebaseAuth.instance.currentUser != null) {
    switch (message.data['funName']) {
      case 'requestTheRiderAboutNewTrip':
        handleRequestTheRiderAboutNewTripOnClick(message);
        break;
    }
  }
}
