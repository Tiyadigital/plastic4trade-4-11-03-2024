class RegisterUserPhoneno {
  int? status;
  bool? otpSent;
  String? message;
  Result? result;

  RegisterUserPhoneno({this.status, this.otpSent, this.message, this.result});

  RegisterUserPhoneno.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otpSent = json['otp_sent'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['otp_sent'] = this.otpSent;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? userid;
  int? countryCode;
  int? phoneno;
  int? smsCode;
  String? userName;
  int? stepCounter;
  String? userToken;

  Result(
      {this.userid,
        this.countryCode,
        this.phoneno,
        this.smsCode,
        this.userName,
        this.stepCounter,
        this.userToken});

  Result.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    countryCode = json['countryCode'];
    phoneno = json['phoneno'];
    smsCode = json['sms_code'];
    userName = json['userName'];
    stepCounter = json['step_counter'];
    userToken = json['userToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['countryCode'] = this.countryCode;
    data['phoneno'] = this.phoneno;
    data['sms_code'] = this.smsCode;
    data['userName'] = this.userName;
    data['step_counter'] = this.stepCounter;
    data['userToken'] = this.userToken;
    return data;
  }
}
