class GetCategoryGrade {
  int? status;
  String? message;
  List<Result>? result;

  GetCategoryGrade({this.status, this.message, this.result});

  GetCategoryGrade.fromJson(Map<String, dynamic> json) {
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
  int? productgradeId;
  String? productGrade;

  Result({this.productgradeId, this.productGrade});

  Result.fromJson(Map<String, dynamic> json) {
    productgradeId = json['productgradeId'];
    productGrade = json['ProductGrade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productgradeId'] = this.productgradeId;
    data['ProductGrade'] = this.productGrade;
    return data;
  }
}
