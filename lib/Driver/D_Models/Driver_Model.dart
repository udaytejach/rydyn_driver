class DriverModel {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? status;
  String? dob;
  String? vehicleType;
  String? licenceNumber;
  String? profileUrl;
  String? licenceFrontUrl;
  String? licenceBackUrl;
  String? aadharFrontUrl;
  String? aadharBackUrl;
  BankAccount? bankAccount;
  String? roleCode;
  String? countryCode;
  String? rejectReason;
  bool? isOnline;

  DriverModel({
    this.userId,
    this.isOnline,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.dob,
    this.vehicleType,
    this.licenceNumber,
    this.profileUrl,
    this.licenceFrontUrl,
    this.licenceBackUrl,
    this.aadharFrontUrl,
    this.aadharBackUrl,
    this.bankAccount,
    this.roleCode,
    this.rejectReason,
    this.status,
    this.countryCode,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "isOnline": false,
    "firstName": firstName,
    "lastName": lastName,
    'countryCode': countryCode,
    "email": email,
    "phone": phone,
    'rejectReason': rejectReason,
    "dob": dob,
    "status": status,
    "vehicleType": vehicleType,
    "licenceNumber": licenceNumber,
    "profileUrl": profileUrl,
    "licenceFrontUrl": licenceFrontUrl,
    "licenceBackUrl": licenceBackUrl,
    "aadharFrontUrl": aadharFrontUrl,
    "aadharBackUrl": aadharBackUrl,
    "bankAccount": bankAccount?.toJson(),
    "roleCode": roleCode,
  };
}

class BankAccount {
  String? holderName;
  String? accountNumber;
  String? ifsc;
  String? bankName;
  String? branch;

  BankAccount({
    this.holderName,
    this.accountNumber,
    this.ifsc,
    this.bankName,
    this.branch,
  });

  Map<String, dynamic> toJson() => {
    "holderName": holderName,
    "accountNumber": accountNumber,
    "ifsc": ifsc,
    "bankName": bankName,
    "branch": branch,
  };
}
