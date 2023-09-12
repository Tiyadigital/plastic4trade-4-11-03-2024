class GetProductName {
  int? _status;
  String? _message;
  List<Result>? _result;

  GetProductName({int? status, String? message, List<Result>? result}) {
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
  List<Result>? get result => _result;
  set result(List<Result>? result) => _result = result;

  GetProductName.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    if (json['result'] != null) {
      _result = <Result>[];
      json['result'].forEach((v) {
        _result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._result != null) {
      data['result'] = this._result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? _productName;

  Result({String? productName}) {
    if (productName != null) {
      this._productName = productName;
    }
  }

  String? get productName => _productName;
  set productName(String? productName) => _productName = productName;

  Result.fromJson(Map<String, dynamic> json) {
    _productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this._productName;
    return data;
  }
}
