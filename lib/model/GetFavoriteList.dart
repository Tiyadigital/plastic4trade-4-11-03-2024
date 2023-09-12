class GetFavoriteList {
  int? status;
  String? message;
  List<Result>? result;

  GetFavoriteList({this.status, this.message, this.result});

  GetFavoriteList.fromJson(Map<String, dynamic> json) {
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
  int? favoriteId;
  String? productId;
  String? postType;
  String? userId;
  String? userName;
  String? productName;
  String? categoryId;
  String? categoryName;
  String? productTypeId;
  String? productType;
  String? productGradeId;
  String? productGrade;
  String? currency;
  String? productPrice;
  String? mainproductImage;
  String? city;
  String? state;
  String? country;

  Result(
      {this.favoriteId,
        this.productId,
        this.postType,
        this.userId,
        this.userName,
        this.productName,
        this.categoryId,
        this.categoryName,
        this.productTypeId,
        this.productType,
        this.productGradeId,
        this.productGrade,
        this.currency,
        this.productPrice,
        this.mainproductImage,
        this.city,
        this.state,
        this.country});

  Result.fromJson(Map<String, dynamic> json) {
    favoriteId = json['FavoriteId'];
    productId = json['productId'];
    postType = json['PostType'];
    userId = json['UserId'];
    userName = json['UserName'];
    productName = json['ProductName'];
    categoryId = json['CategoryId'];
    categoryName = json['CategoryName'];
    productTypeId = json['ProductTypeId'];
    productType = json['ProductType'];
    productGradeId = json['ProductGradeId'];
    productGrade = json['ProductGrade'];
    currency = json['Currency'];
    productPrice = json['ProductPrice'];
    mainproductImage = json['mainproductImage'];
    city = json['City'];
    state = json['State'];
    country = json['Country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FavoriteId'] = this.favoriteId;
    data['productId'] = this.productId;
    data['PostType'] = this.postType;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['ProductName'] = this.productName;
    data['CategoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    data['ProductTypeId'] = this.productTypeId;
    data['ProductType'] = this.productType;
    data['ProductGradeId'] = this.productGradeId;
    data['ProductGrade'] = this.productGrade;
    data['Currency'] = this.currency;
    data['ProductPrice'] = this.productPrice;
    data['mainproductImage'] = this.mainproductImage;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Country'] = this.country;
    return data;
  }
}
