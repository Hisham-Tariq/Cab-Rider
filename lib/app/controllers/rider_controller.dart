import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rider.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class RiderController extends GetxController {
  RiderModel _rider = RiderModel();
  final _riderDataReference = FirebaseFirestore.instance.collection('rider');
  StreamSubscription<dynamic>? _riderDataListener;

  RiderModel get rider => _rider;
  setUser(RiderModel rider) {
    _rider = rider;
  }

  String? get currentRiderPhoneNumber =>
      FirebaseAuth.instance.currentUser!.phoneNumber;
  String? get currentRiderUID => FirebaseAuth.instance.currentUser!.uid;

  bool get isRiderNotLoggedIn => FirebaseAuth.instance.currentUser == null;

  Future<bool> createRider() async {
    if (_rider.firstName == null) return false;

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var userData = _rider.toJsonToCreateRider();
    try {
      await _riderDataReference.doc(currentUserId).set(userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signOutRider() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print('Error: in signOutRider\n$e');
      return true;
    }
  }

  listenToRiderData() {
    try {
      if (currentRiderUID != null) {
        _riderDataListener = _riderDataReference
            .doc(currentRiderUID)
            .snapshots()
            .listen((event) {
          this._rider = RiderModel.fromJson(event.data(), event.id);
          update();
        });
      }
    } catch (e) {
      print('Error: in readCurrentUser\n $e');
    }
  }

  Future<bool> readCurrentUser() async {
    try {
      if (currentRiderUID != null) {
        var riderData = await _riderDataReference.doc(currentRiderUID).get();
        this._rider = RiderModel.fromJson(riderData.data(), riderData.id);
      }
      listenToRiderData();
      return true;
    } catch (e) {
      print('Error: in readCurrentUser\n $e');
      listenToRiderData();
      return false;
    }
  }

  readUser(id) {}
  readAllUsers() {}

  Future<dynamic> riderWithPhoneNumberIsExistInFirestore(
      String phoneNumber) async {
    try {
      var _rider = await _riderDataReference
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return _rider.docs.length > 0;
    } catch (e) {
      print('Error: IN riderWithPhoneNumberExist\n$e');
      return true;
    }
  }

  Future<bool> isRiderApproved() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  onCompleteTrip() {
    _riderDataReference.doc(currentRiderUID).update({
      'eligible': true,
      'currentBooking': FieldValue.delete(),
    });
  }

  bool get isRiderHaveCurrentTrip {
    return !(_rider.eligible as bool) && _rider.currentBooking != null;
  }

  changeRiderStatus(bool value) {
    if (value) {
      FirebaseMessaging.instance.subscribeToTopic('drivers');
      printInfo(info: 'Subscribed to drivers topic');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('drivers');
      printInfo(info: 'Unsubscribed to drivers topic');
    }
    _riderDataReference.doc(currentRiderUID).update({'riderStatus': value});
    update();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _riderDataListener!.cancel();
  }
}
