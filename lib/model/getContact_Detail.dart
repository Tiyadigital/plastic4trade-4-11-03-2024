class getContact_Detail {
  int? _status;
  String? _message;
  Result? _result;

  getContact_Detail({int? status, String? message, Result? result}) {
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (result != null) {
      this._result = result;
    }
  }

  int? get status => _status;
  set status(int? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  Result? get result => _result;
  set result(Result? result) => _result = result;

  getContact_Detail.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._result != null) {
      data['result'] = this._result!.toJson();
    }
    return data;
  }
}

class Result {
  String? _location;
  String? _countryCode;
  String? _phone;
  String? _email;

  Result(
      {String? location, String? countryCode, String? phone, String? email}) {
    if (location != null) {
      this._location = location;
    }
    if (countryCode != null) {
      this._countryCode = countryCode;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (email != null) {
      this._email = email;
    }
  }

  String? get location => _location;
  set location(String? location) => _location = location;
  String? get countryCode => _countryCode;
  set countryCode(String? countryCode) => _countryCode = countryCode;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get email => _email;
  set email(String? email) => _email = email;

  Result.fromJson(Map<String, dynamic> json) {
    _location = json['location'];
    _countryCode = json['countryCode'];
    _phone = json['phone'];
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this._location;
    data['countryCode'] = this._countryCode;
    data['phone'] = this._phone;
    data['email'] = this._email;
    return data;
  }
}
