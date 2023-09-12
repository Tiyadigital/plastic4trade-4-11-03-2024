class GetCategory {
  int? status;
  String? message;
  List<Result>? result;

  GetCategory({this.status, this.message, this.result});

  GetCategory.fromJson(Map<String, dynamic> json) {
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
  int? categoryId;
  String? categoryName;
  String? categoryImage;

  Result({this.categoryId, this.categoryName, this.categoryImage});

  Result.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['CategoryName'];
    categoryImage = json['categoryImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    data['categoryImage'] = this.categoryImage;
    return data;
  }
}
