class getAbout_us {
  int? _status;
  String? _message;
  Result? _result;

  getAbout_us({int? status, String? message, Result? result}) {
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

  getAbout_us.fromJson(Map<String, dynamic> json) {
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
  int? _staticId;
  String? _staticTitle;
  String? _staticDescription;

  Result({int? staticId, String? staticTitle, String? staticDescription}) {
    if (staticId != null) {
      this._staticId = staticId;
    }
    if (staticTitle != null) {
      this._staticTitle = staticTitle;
    }
    if (staticDescription != null) {
      this._staticDescription = staticDescription;
    }
  }

  int? get staticId => _staticId;
  set staticId(int? staticId) => _staticId = staticId;
  String? get staticTitle => _staticTitle;
  set staticTitle(String? staticTitle) => _staticTitle = staticTitle;
  String? get staticDescription => _staticDescription;
  set staticDescription(String? staticDescription) =>
      _staticDescription = staticDescription;

  Result.fromJson(Map<String, dynamic> json) {
    _staticId = json['staticId'];
    _staticTitle = json['staticTitle'];
    _staticDescription = json['staticDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staticId'] = this._staticId;
    data['staticTitle'] = this._staticTitle;
    data['staticDescription'] = this._staticDescription;
    return data;
  }
}
