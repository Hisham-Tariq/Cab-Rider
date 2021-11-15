import 'dart:async';

import 'package:cab_rider_its/app/customization/customization.dart';
import 'package:cab_rider_its/app/generated/assets.dart';
import 'package:cab_rider_its/app/ui/global_widgets/global_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_dialogs/material_dialogs.dart';
import '../models/models.dart';
import 'direction_controller.dart';
import 'rider_controller.dart';

class CurrentTripController extends GetxController {
  LatLng? _currentLocation;
  BookedTripModel? trip;
  DocumentReference<dynamic>? _currentBookingReference;
  final RxString tripStatus = 'Pending'.obs;
  late StreamSubscription<Position> _positionStream;
  Directions? _tripDirections;
  String? bookingId;
  late StreamSubscription<dynamic> _tripListener;
  bool? isPositionStreamCancel;

  onInit() async {
    super.onInit();
    print(Get.find<RiderController>().rider.currentBooking);
    bookingId = Get.find<RiderController>().rider.currentBooking;
    if (bookingId != null) {
      _currentBookingReference =
          FirebaseFirestore.instance.collection('BookedTrips').doc(bookingId);
      _listenToBookedTripForChanges();
      initPositionStream();
    }
    update();
  }

  @override
  void onClose() {
    if (this.isPositionStreamCancel != null &&
        !(this.isPositionStreamCancel as bool)) {
      print('Position Stream is Cancelled');
      _positionStream.cancel();
    }
  }

  _listenToBookedTripForChanges() {
    _tripListener = _currentBookingReference!.snapshots().listen((event) async {
      trip = BookedTripModel.fromJson(event.data(), event.id);
      if (trip!.tripStatus == TripStatus.ended) {
        _tripListener.cancel();
        _onRideComplete();
        await _removeTheRidersCurrentBooking();
        var arguments = <String, dynamic>{
          "bookingId": bookingId,
        };
        Get.offNamed('/rideFeedBack', arguments: arguments);
      }
      update();
    });
  }

  Future _onRideComplete() async {
    var rider = Get.find<RiderController>();
    await FirebaseFirestore.instance
        .collection('rider')
        .doc(rider.currentRiderUID)
        .update({
      'balanceToPay': rider.rider.balanceToPay! + this.trip!.tripPrice,
    });
    return _currentBookingReference!.update({
      'completedAt': FieldValue.serverTimestamp(),
    });
  }

  Future _removeTheRidersCurrentBooking() {
    return FirebaseFirestore.instance
        .collection('rider')
        .doc(Get.find<RiderController>().currentRiderUID)
        .update({
      'eligible': true,
      'currentBooking': FieldValue.delete(),
    });
  }

  updateTripStatus(status) async {
    try {
      await _currentBookingReference!.update({'tripStatus': status});
      update();
      printInfo(info: 'Trip Status updated to $status');
      return true;
    } catch (e) {
      printError(info: 'Error: $e');
      return false;
    }
  }

  initPositionStream() async {
    var data = await _currentBookingReference!.get();
    trip = BookedTripModel.fromJson(data.data(), data.id);
    isPositionStreamCancel = false;
    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .listen((event) {
      print('Direction Changed');
      this.currentLocation = LatLng(event.latitude, event.longitude);
      if (trip!.tripStatus == TripStatus.pending)
        _fetchTripDirection(
            this.currentLocation as LatLng, trip!.userPickupLocation);
      if (trip!.tripStatus == TripStatus.started)
        _fetchTripDirection(
            this.currentLocation as LatLng, trip!.userDestinationLocation);
      if (trip!.tripStatus == TripStatus.ended) {
        if (!(this.isPositionStreamCancel as bool)) {
          _positionStream.cancel();
          print('Position Stream is Cancelled');
        }
        _tripDirections = null;
        this.isPositionStreamCancel = true;
      }
      update();
    });
  }

  set currentLocation(value) => _currentLocation = value;

  LatLng? get currentLocation => _currentLocation;

  Directions? get tripDirections => _tripDirections;

  set tripDirections(Directions? value) {
    _tripDirections = value;
  }

  _fetchTripDirection(LatLng origin, LatLng destination) async {
    final directions = await DirectionsController().getDirections(
      origin: origin,
      destination: destination,
    );
    _tripDirections = directions;
  }

  onStartTrip() async {
    //  SHow Dialog to wait till the customer accept
    await Get.bottomSheet(
      _RequestToStartSheet(),
      ignoreSafeArea: true,
      isDismissible: false,
      persistent: true,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(200, 40),
          topRight: Radius.elliptical(200, 40),
        ),
      ),
    );
    return true;
  }

  onEndTrip() async {
    //  SHow Dialog to wait till the customer accept
    await Get.bottomSheet(
      _RequestToEndSheet(),
      ignoreSafeArea: true,
      isDismissible: false,
      persistent: true,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(200, 40),
          topRight: Radius.elliptical(200, 40),
        ),
      ),
    );
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _RequestToStartSheet extends StatefulWidget {
  const _RequestToStartSheet({Key? key}) : super(key: key);

  @override
  __RequestToStartSheetState createState() => __RequestToStartSheetState();
}

class __RequestToStartSheetState extends State<_RequestToStartSheet> {
  bool _userResponse = false;
  bool isProcessing = true;
  var controller = Get.find<CurrentTripController>();
  late StreamSubscription<dynamic> _userResponseListener;

  bool isSubscriptionActive = false;

  @override
  void initState() {
    super.initState();
    requestToConfirm();
  }

  requestToConfirm() async {
    if (!this.isProcessing)
      this.setState(() {
        this.isProcessing = true;
      });
    await _intiResponseDoc();
    _listenResponseDoc();
    _requestToConfirm();
  }

  _intiResponseDoc() async {
    await FirebaseFirestore.instance
        .collection('BookedTrips')
        .doc(controller.bookingId)
        .collection('response')
        .doc('start')
        .set({
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }

  _listenResponseDoc() {
    if (this.isSubscriptionActive) _userResponseListener.cancel();
    _userResponseListener = FirebaseFirestore.instance
        .collection('BookedTrips')
        .doc(controller.bookingId)
        .collection('response')
        .doc('start')
        .snapshots()
        .listen((event) {
      if (event.data()!.containsKey('response')) {
        print('User Responded with: ${event['response']}');
        this.setState(() {
          _userResponseListener.cancel();
          this.isSubscriptionActive = false;
          this._userResponse = event['response'];
          this.isProcessing = false;
          if (this._userResponse) {
            controller.updateTripStatus(TripStatus.started);
          }
        });
      }
    });
    this.isSubscriptionActive = true;
  }

  _requestToConfirm() async {
    print('Starting to Request the User');
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('confirmUserTripHasStarted');
    callable.call(<String, dynamic>{
      'docId': 'start',
      'userId': controller.trip!.userId,
    }).then((value) {
      print('Returned Value from Server: $value');
    }, onError: (error) {
      print('Error Occurred in HTTP Call $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Current User Response: ${this._userResponse}');
    print('isRequesting: ${this.isProcessing}');
    print('isSubscriptionActive: ${this.isSubscriptionActive}');
    return Material(
      child: Container(
        height: 400,
        color: Colors.white,
        padding: EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Text(
                'Start Trip',
                textAlign: TextAlign.center,
                style: GoogleFonts.catamaran(
                  fontWeight: FontWeight.w900,
                  fontSize: 24.0,
                  color: AppColors.primary,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    _getRespectiveAnim(),
                    width: 150,
                    height: 150,
                  ),
                  VerticalAppSpacer(space: 24.0),
                  Text(
                    _getRespectiveText(),
                    style: GoogleFonts.catamaran(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                      color: _getTextColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _getRespectiveButton(),
          ],
        ),
      ),
    );
  }

  _getRespectiveAnim() {
    if (this.isProcessing)
      return Assets.animLoading;
    else if (!this.isProcessing && this._userResponse == true)
      return Assets.animSuccessResponse;
    else if (!this.isProcessing && this._userResponse == false)
      return Assets.animRejectResponse;
  }

  _getRespectiveButton() {
    Widget button = Container();
    if (this.isProcessing)
      button = Container(
        child: FullOutlinedTextButton(
          buttonColor: AppColors.primary,
          text: 'Request Again',
          onPressed: requestToConfirm,
        ),
      );
    else if (!this.isProcessing && this._userResponse == true)
      button = TimerButton(
        time: 3,
        title: 'Close',
        backgroundColor: Colors.white,
        borderColor: AppColors.primary,
        textColor: AppColors.primary,
        onTap: Get.back,
      );
    else if (!this.isProcessing && this._userResponse == false)
      button = Container(
        child: FullOutlinedTextButton(
          buttonColor: AppColors.error,
          text: 'Request Again',
          onPressed: requestToConfirm,
        ),
      );
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: button,
    );
  }

  _getRespectiveText() {
    if (this.isProcessing)
      return 'Wait for the customer to accept';
    else if (!this.isProcessing && this._userResponse == true)
      return 'Customer have accepted';
    else if (!this.isProcessing && this._userResponse == false)
      return 'Customer have rejected try again';
  }

  _getTextColor() {
    if (!this.isProcessing && this._userResponse == false)
      return AppColors.error;
    else
      return AppColors.primary;
  }
}

class _RequestToEndSheet extends StatefulWidget {
  const _RequestToEndSheet({Key? key}) : super(key: key);

  @override
  __RequestToEndSheetState createState() => __RequestToEndSheetState();
}

class __RequestToEndSheetState extends State<_RequestToEndSheet> {
  bool _userResponse = false;
  bool isProcessing = true;
  var controller = Get.find<CurrentTripController>();
  late StreamSubscription<dynamic> _userResponseListener;
  bool isSubscriptionCanceled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestUser();
  }

  requestUser() async {
    if (!this.isProcessing)
      this.setState(() {
        this.isProcessing = true;
      });
    await _intiResponseDoc();
    _listenResponseDoc();
    _requestToConfirm();
  }

  _intiResponseDoc() async {
    await FirebaseFirestore.instance
        .collection('BookedTrips')
        .doc(controller.bookingId)
        .collection('response')
        .doc('end')
        .set({
      'requestedAt': FieldValue.serverTimestamp(),
    });
  }

  _listenResponseDoc() {
    if (!this.isSubscriptionCanceled) _userResponseListener.cancel();
    _userResponseListener = FirebaseFirestore.instance
        .collection('BookedTrips')
        .doc(controller.bookingId)
        .collection('response')
        .doc('end')
        .snapshots()
        .listen((event) {
      if (event.data()!.containsKey('response')) {
        if (event.data()!.containsKey('response')) {
          this.setState(() {
            _userResponseListener.cancel();
            this.isSubscriptionCanceled = true;
            this._userResponse = event['response'];
            this.isProcessing = false;
          });
        }
      }
    });
    this.isSubscriptionCanceled = false;
  }

  _requestToConfirm() {
    print('Starting to Request the User');
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('confirmUserTripHasEnded');
    callable.call(<String, dynamic>{
      'docId': 'end',
      'userId': controller.trip!.userId,
    }).then((value) {
      print('Returned Value from Server: $value');
    }, onError: (error) {
      print('Error Occurred in HTTP Call $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 400,
        color: Colors.white,
        padding: EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Text(
                'End Trip',
                textAlign: TextAlign.center,
                style: GoogleFonts.catamaran(
                  fontWeight: FontWeight.w900,
                  fontSize: 24.0,
                  color: AppColors.primary,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    _getRespectiveAnim(),
                    width: 150,
                    height: 150,
                  ),
                  VerticalAppSpacer(space: 24.0),
                  Text(
                    _getRespectiveText(),
                    style: GoogleFonts.catamaran(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                      color: _getTextColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _getRespectiveButton(),
          ],
        ),
      ),
    );
  }

  _getRespectiveAnim() {
    if (this.isProcessing)
      return Assets.animLoading;
    else if (!this.isProcessing && this._userResponse == true)
      return Assets.animSuccessResponse;
    else if (!this.isProcessing && this._userResponse == false)
      return Assets.animRejectResponse;
  }

  _getRespectiveButton() {
    Widget button = Container();
    if (this.isProcessing)
      button = Container(
        child: FullOutlinedTextButton(
          buttonColor: AppColors.primary,
          text: 'Request Again',
          onPressed: requestUser,
        ),
      );
    else if (!this.isProcessing && this._userResponse == true)
      button = TimerButton(
        time: 3,
        title: 'Close',
        backgroundColor: Colors.white,
        borderColor: AppColors.primary,
        textColor: AppColors.primary,
        onTap: () {
          Get.back();
          if (this._userResponse) {
            controller.updateTripStatus(TripStatus.ended);
          }
        },
      );
    else if (!this.isProcessing && this._userResponse == false)
      button = Container(
        child: FullOutlinedTextButton(
          buttonColor: AppColors.error,
          text: 'Request Again',
          onPressed: requestUser,
        ),
      );
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: button,
    );
  }

  _getRespectiveText() {
    if (this.isProcessing)
      return 'Wait for the customer to accept';
    else if (!this.isProcessing && this._userResponse == true)
      return 'Customer have accepted';
    else if (!this.isProcessing && this._userResponse == false)
      return 'Customer have rejected try again';
  }

  _getTextColor() {
    if (!this.isProcessing && this._userResponse == false)
      return AppColors.error;
    else
      return AppColors.primary;
  }
}
