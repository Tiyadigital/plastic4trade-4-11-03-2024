class Login {
  int? status;
  String? message;
  Result? result;

  Login({this.status, this.message, this.result});

  Login.fromJson(Map<String, dynamic> json) {
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
  String? countryCode;
  String? phoneno;
  String? userToken;
  String? userImage;
  String? latitude;
  String? longitude;
  int? stepCounter;

  Result(
      {this.userid,
        this.userName,
        this.email,
        this.countryCode,
        this.phoneno,
        this.userToken,
        this.userImage,
        this.latitude,
        this.longitude,
        this.stepCounter});

  Result.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    userName = json['userName'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneno = json['phoneno'];
    userToken = json['userToken'];
    userImage = json['userImage'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    stepCounter = json['step_counter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['phoneno'] = this.phoneno;
    data['userToken'] = this.userToken;
    data['userImage'] = this.userImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['step_counter'] = this.stepCounter;
    return data;
  }
}
