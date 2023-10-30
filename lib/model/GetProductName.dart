class GetProductName {
  int? _status;
  String? _message;
  List<Result>? _result;

  GetProductName({int? status, String? message, List<Result>? result}) {
    if (status != null) {
      _status = status;
    }
    if (message != null) {
      _message = message;
    }
    if (result != null) {
      _result = result;
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
        _result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['message'] = _message;
    if (_result != null) {
      data['result'] = _result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? _productName;

  Result({String? productName}) {
    if (productName != null) {
      _productName = productName;
    }
  }

  String? get productName => _productName;
  set productName(String? productName) => _productName = productName;

  Result.fromJson(Map<String, dynamic> json) {
    _productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productName'] = _productName;
    return data;
  }
}
