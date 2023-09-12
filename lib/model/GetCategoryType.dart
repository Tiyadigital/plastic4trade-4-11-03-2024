class GetCategoryType {
  int? status;
  String? message;
  List<Result>? result;

  GetCategoryType({this.status, this.message, this.result});

  GetCategoryType.fromJson(Map<String, dynamic> json) {
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
  int? producttypeId;
  String? productType;
  String? producttypeImage;

  Result({this.producttypeId, this.productType, this.producttypeImage});

  Result.fromJson(Map<String, dynamic> json) {
    producttypeId = json['producttypeId'];
    productType = json['ProductType'];
    producttypeImage = json['producttypeImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['producttypeId'] = this.producttypeId;
    data['ProductType'] = this.productType;
    data['producttypeImage'] = this.producttypeImage;
    return data;
  }
}
