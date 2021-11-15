import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookedTripModel {
  late String? id;
  late String userId;
  late String userName;
  late String userPhone;
  late Timestamp? bookedAt;
  late LatLng userPickupLocation;
  late LatLng userDestinationLocation;
  late String riderId;
  late String riderName;
  late String riderPhone;
  late int tripPrice;
  late double tripDistance;
  late String vehicleType;
  late String tripStatus;
  late Timestamp? completedAt;

  BookedTripModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userPickupLocation,
    required this.userDestinationLocation,
    required this.riderId,
    required this.riderName,
    required this.riderPhone,
    required this.tripPrice,
    required this.tripDistance,
    required this.vehicleType,
    this.bookedAt,
    this.completedAt,
  });

  BookedTripModel.fromJson(Map<String, dynamic>? json, String id) {
    this.id = id;
    this.userId = json!['userId'];
    this.userName = json['userName'];
    this.userPhone = json['userPhone'];
    this.userPickupLocation = _mapToLatLng(json['userPickupLocation']);
    this.userDestinationLocation =
        _mapToLatLng(json['userDestinationLocation']);
    this.riderId = json['riderId'];
    this.riderName = json['riderName'];
    this.riderPhone = json['riderPhone'];
    this.tripPrice = json['tripPrice'];
    this.tripDistance = json['tripDistance'];
    this.vehicleType = json['vehicleType'];
    this.tripStatus = json['tripStatus'];
    this.bookedAt = json['bookedAt'];
    if (json.containsKey('completedAt')) this.completedAt = json['completedAt'];
  }
  //[0-9]*\.[0-9]
  Map<String, double> _latLngToMap(LatLng loc) {
    return {
      'lat': loc.latitude,
      'lng': loc.longitude,
    };
  }

  LatLng _mapToLatLng(Map<String, dynamic> loc) {
    return LatLng(loc['lat']!, loc['lng']!);
  }

  Map<String, dynamic> toCreateJson() => {
        'userId': this.userId,
        'userName': this.userName,
        'userPhone': this.userPhone,
        'userPickupLocation': _latLngToMap(userPickupLocation),
        'userDestinationLocation': _latLngToMap(userDestinationLocation),
        'riderId': this.riderId,
        'riderName': this.riderName,
        'riderPhone': this.riderPhone,
        'tripPrice': this.tripPrice,
        'tripDistance': this.tripDistance,
        'vehicleType': this.vehicleType,
        'bookedAt': FieldValue.serverTimestamp(),
        'tripStatus': 'pending',
      };
  Map<String, dynamic> toJson() =>
      {'id': id, 'userLocation': userPickupLocation};
}
