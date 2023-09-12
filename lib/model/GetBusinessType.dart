class GetBusinessType {
  int? status;
  String? message;
  List<Result>? result;

  GetBusinessType({this.status, this.message, this.result});

  GetBusinessType.fromJson(Map<String, dynamic> json) {
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
  int? businessTypeId;
  String? businessType;

  Result({this.businessTypeId, this.businessType});

  Result.fromJson(Map<String, dynamic> json) {
    businessTypeId = json['BusinessTypeId'];
    businessType = json['BusinessType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BusinessTypeId'] = this.businessTypeId;
    data['BusinessType'] = this.businessType;
    return data;
  }
}
