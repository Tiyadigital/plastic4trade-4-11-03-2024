class FinalRegister {
  int? status;
  String? message;
  Result? result;

  FinalRegister({this.status, this.message, this.result});

  FinalRegister.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? userid;
  String? userName;
  String? email;
  String? userToken;
  String? countryCode;
  String? phoneno;
  String? smsCode;
  String? emailCode;
  int? stepCounter;

  Result(
      {this.userid,
        this.userName,
        this.email,
        this.userToken,
        this.countryCode,
        this.phoneno,
        this.smsCode,
        this.emailCode,
        this.stepCounter});

  Result.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    userName = json['userName'];
    email = json['email'];
    userToken = json['userToken'];
    countryCode = json['countryCode'];
    phoneno = json['phoneno'];
    smsCode = json['sms_code']!=null?json['sms_code']:"";
    emailCode = json['email_code'];
    stepCounter = json['step_counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['userToken'] = this.userToken;
    data['countryCode'] = this.countryCode;
    data['phoneno'] = this.phoneno;
    data['sms_code'] = this.smsCode;
    data['email_code'] = this.emailCode;
    data['step_counter'] = this.stepCounter;
    return data;
  }
}
