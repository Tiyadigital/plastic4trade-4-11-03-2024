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
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FavoriteId'] = favoriteId;
    data['productId'] = productId;
    data['PostType'] = postType;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['ProductName'] = productName;
    data['CategoryId'] = categoryId;
    data['CategoryName'] = categoryName;
    data['ProductTypeId'] = productTypeId;
    data['ProductType'] = productType;
    data['ProductGradeId'] = productGradeId;
    data['ProductGrade'] = productGrade;
    data['Currency'] = currency;
    data['ProductPrice'] = productPrice;
    data['mainproductImage'] = mainproductImage;
    data['City'] = city;
    data['State'] = state;
    data['Country'] = country;
    return data;
  }
}
