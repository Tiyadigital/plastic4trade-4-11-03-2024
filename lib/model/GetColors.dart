class GetColors {
  int? status;
  String? message;
  List<Result>? result;

  GetColors({this.status, this.message, this.result});

  GetColors.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? colorId;
  String? colorName;

  Result({this.colorId, this.colorName});

  Result.fromJson(Map<String, dynamic> json) {
    colorId = json['colorId'];
    colorName = json['ColorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colorId'] = this.colorId;
    data['ColorName'] = this.colorName;
    return data;
  }
}
