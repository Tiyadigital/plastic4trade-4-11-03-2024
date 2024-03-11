class Login {
  int? status;
  String? message;
  Result? result;

  Login({this.status, this.message, this.result});

  Login.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['userName'] = userName;
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['phoneno'] = phoneno;
    data['userToken'] = userToken;
    data['userImage'] = userImage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['step_counter'] = stepCounter;
    return data;
  }
}
