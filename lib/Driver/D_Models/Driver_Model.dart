class DriverModel {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? dob;
  String? vehicleType;
  String? licenceNumber;
  String? profileUrl;
  String? licenceFrontUrl;
  String? licenceBackUrl;
  BankAccount? bankAccount;
  String? roleCode;
  String? countryCode;
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
    this.bankAccount,
    this.roleCode,
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
    "dob": dob,
    "vehicleType": vehicleType,
    "licenceNumber": licenceNumber,
    "profileUrl": profileUrl,
    "licenceFrontUrl": licenceFrontUrl,
    "licenceBackUrl": licenceBackUrl,
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
