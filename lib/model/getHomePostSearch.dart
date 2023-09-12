class getHomePostSearch {
  int? status;
  String? message;
  List<Result>? result;

  getHomePostSearch({this.status, this.message, this.result});

  getHomePostSearch.fromJson(Map<String, dynamic> json) {
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
  int? productId;
  int? userId;
  String? userName;
  String? userEmail;
  String? postType;
  String? categoryId;
  String? categoryName;
  String? postName;
  String? productTypeId;
  String? productType;
  String? productGradeId;
  String? productGrade;
  String? currency;
  String? productPrice;
  String? unit;
  String? postQuntity;
  List<PostColor>? postColor;
  String? location;
  String? latitude;
  String? longitude;
  String? city;
  String? state;
  String? country;
  String? description;
  String? mainproductImage;
  List<SubproductImage>? subproductImage;
  String? isPaidPost;

  Result(
      {this.productId,
        this.userId,
        this.userName,
        this.userEmail,
        this.postType,
        this.categoryId,
        this.categoryName,
        this.postName,
        this.productTypeId,
        this.productType,
        this.productGradeId,
        this.productGrade,
        this.currency,
        this.productPrice,
        this.unit,
        this.postQuntity,
        this.postColor,
        this.location,
        this.latitude,
        this.longitude,
        this.city,
        this.state,
        this.country,
        this.description,
        this.mainproductImage,
        this.subproductImage,
        this.isPaidPost});

  Result.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    userId = json['UserId'];
    userName = json['UserName'];
    userEmail = json['UserEmail'];
    postType = json['PostType'];
    categoryId = json['categoryId'];
    categoryName = json['CategoryName'];
    postName = json['PostName'];
    productTypeId = json['ProductTypeId'];
    productType = json['ProductType'];
    productGradeId = json['ProductGradeId'];
    productGrade = json['ProductGrade'];
    currency = json['Currency'];
    productPrice = json['ProductPrice'];
    unit = json['Unit'];
    postQuntity = json['PostQuntity'];
    if (json['PostColor'] != null) {
      postColor = <PostColor>[];
      json['PostColor'].forEach((v) {
        postColor!.add(new PostColor.fromJson(v));
      });
    }
    location = json['Location'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    city = json['City'];
    state = json['State'];
    country = json['Country'];
    description = json['Description'];
    mainproductImage = json['mainproductImage'];
    if (json['subproductImage'] != null) {
      subproductImage = <SubproductImage>[];
      json['subproductImage'].forEach((v) {
        subproductImage!.add(new SubproductImage.fromJson(v));
      });
    }
    isPaidPost = json['is_paid_post'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UserEmail'] = this.userEmail;
    data['PostType'] = this.postType;
    data['categoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    data['PostName'] = this.postName;
    data['ProductTypeId'] = this.productTypeId;
    data['ProductType'] = this.productType;
    data['ProductGradeId'] = this.productGradeId;
    data['ProductGrade'] = this.productGrade;
    data['Currency'] = this.currency;
    data['ProductPrice'] = this.productPrice;
    data['Unit'] = this.unit;
    data['PostQuntity'] = this.postQuntity;
    if (this.postColor != null) {
      data['PostColor'] = this.postColor!.map((v) => v.toJson()).toList();
    }
    data['Location'] = this.location;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Country'] = this.country;
    data['Description'] = this.description;
    data['mainproductImage'] = this.mainproductImage;
    if (this.subproductImage != null) {
      data['subproductImage'] =
          this.subproductImage!.map((v) => v.toJson()).toList();
    }
    data['is_paid_post'] = this.isPaidPost;
    return data;
  }
}

class PostColor {
  String? colorId;
  String? colorName;
  String? haxCode;

  PostColor({this.colorId, this.colorName, this.haxCode});

  PostColor.fromJson(Map<String, dynamic> json) {
    colorId = json['colorId'];
    colorName = json['colorName'];
    haxCode = json['HaxCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colorId'] = this.colorId;
    data['colorName'] = this.colorName;
    data['HaxCode'] = this.haxCode;
    return data;
  }
}

class SubproductImage {
  int? productImageId;
  String? subImageUrl;

  SubproductImage({this.productImageId, this.subImageUrl});

  SubproductImage.fromJson(Map<String, dynamic> json) {
    productImageId = json['productImageId'];
    subImageUrl = json['sub_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productImageId'] = this.productImageId;
    data['sub_image_url'] = this.subImageUrl;
    return data;
  }
}
