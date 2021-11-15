class RiderModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? cnic;
  String? licenseNo;
  String? vehicleType;
  bool? isApproved;
  String? currentBooking;
  bool? eligible;
  int? balanceToPay;
  bool? riderStatus;
  RiderModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.cnic,
    this.licenseNo,
    this.vehicleType,
    this.isApproved,
    this.currentBooking,
    this.eligible,
    this.balanceToPay,
    this.riderStatus,
  });

  RiderModel.fromJson(Map<String, dynamic>? riderDetail, this.id) {
    firstName = riderDetail!['firstName'];
    lastName = riderDetail['lastName'];
    email = riderDetail['email'];
    phoneNumber = riderDetail['phoneNumber'];
    cnic = riderDetail['cnic'];
    licenseNo = riderDetail['licenseNo'];
    vehicleType = riderDetail['vehicleType'];
    isApproved = riderDetail['isApproved'];
    if (riderDetail.containsKey('eligible'))
      eligible = riderDetail['eligible'];
    if (riderDetail.containsKey('currentBooking'))
      currentBooking = riderDetail['currentBooking'];
    balanceToPay = riderDetail['balanceToPay'];
    riderStatus = riderDetail['riderStatus'];
  }

  Map<String, dynamic> toJsonToCreateRider() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'cnic': cnic,
        'licenseNo': licenseNo,
        'vehicleType': vehicleType,
        'isApproved': false,
        'eligible': true,
        'balanceToPay': 0,
        'riderStatus': true,
      };
}
