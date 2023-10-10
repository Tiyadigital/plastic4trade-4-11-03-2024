// ignore_for_file: prefer_void_to_null

class CommonPostdetail {
  int? status;
  String? message;
  List<Result>? result;

  CommonPostdetail({this.status, this.message, this.result});

  CommonPostdetail.fromJson(Map<String, dynamic> json) {
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
  int? productId;
  int? userId;
  String? username;
  String? businessType;
  String? userImage;
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
  List<PostHaxCodeColor>? postHaxCodeColor;
  String? location;
  String? latitude;
  String? city;
  String? state;
  String? country;
  String? longitude;
  String? description;
  String? mainproductImage;
  List<SubproductImage>? subproductImage;
  String? isLike;
  int? likeCount;
  int? commentCount;
  String? isFavorite;
  String? isFollow;
  int? isView;
  List<SimilarProducts>? similarProducts;
  String? isPaidPost;
  Null unitOfPrice;
  String? updatedDate;
  String? createdDate;

  Result(
      {this.productId,
        this.userId,
        this.username,
        this.businessType,
        this.userImage,
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
        this.postHaxCodeColor,
        this.location,
        this.latitude,
        this.city,
        this.state,
        this.country,
        this.longitude,
        this.description,
        this.mainproductImage,
        this.subproductImage,
        this.isLike,
        this.likeCount,
        this.commentCount,
        this.isFavorite,
        this.isFollow,
        this.isView,
        this.similarProducts,
        this.isPaidPost,
        this.unitOfPrice,
        this.updatedDate,
        this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    userId = json['UserId'];
    username = json['Username'];
    businessType = json['BusinessType'];
    userImage = json['UserImage'];
    postType = json['PostType'];
    categoryId = json['CategoryId'];
    categoryName = json['CategoryName'];
    postName = json['PostName'];
    productTypeId = json['productTypeId'];
    productType = json['ProductType'];
    productGradeId = json['ProductGradeId'];
    productGrade = json['ProductGrade'];
    currency = json['Currency'];
    productPrice = json['ProductPrice'];
    unit = json['Unit'];
    postQuntity = json['PostQuntity'];
    if (json['PostHaxCodeColor'] != null) {
      postHaxCodeColor = <PostHaxCodeColor>[];
      json['PostHaxCodeColor'].forEach((v) {
        postHaxCodeColor!.add(PostHaxCodeColor.fromJson(v));
      });
    }
    location = json['Location'];
    latitude = json['Latitude'];
    city = json['City'];
    state = json['State'];
    country = json['Country'];
    longitude = json['Longitude'];
    description = json['Description'];
    mainproductImage = json['mainproductImage'];
    if (json['subproductImage'] != null) {
      subproductImage = <SubproductImage>[];
      json['subproductImage'].forEach((v) {
        subproductImage!.add(SubproductImage.fromJson(v));
      });
    }
    isLike = json['isLike'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    isFavorite = json['isFavorite'];
    isFollow = json['isFollow'];
    isView = json['isView'];
    if (json['SimilarProducts'] != null) {
      similarProducts = <SimilarProducts>[];
      json['SimilarProducts'].forEach((v) {
        similarProducts!.add(SimilarProducts.fromJson(v));
      });
    }
    isPaidPost = json['is_paid_post'];
    unitOfPrice = json['unit_of_price '];
    updatedDate = json['updated_date'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['UserId'] = userId;
    data['Username'] = username;
    data['BusinessType'] = businessType;
    data['UserImage'] = userImage;
    data['PostType'] = postType;
    data['CategoryId'] = categoryId;
    data['CategoryName'] = categoryName;
    data['PostName'] = postName;
    data['productTypeId'] = productTypeId;
    data['ProductType'] = productType;
    data['ProductGradeId'] = productGradeId;
    data['ProductGrade'] = productGrade;
    data['Currency'] = currency;
    data['ProductPrice'] = productPrice;
    data['Unit'] = unit;
    data['PostQuntity'] = postQuntity;
    if (postHaxCodeColor != null) {
      data['PostHaxCodeColor'] =
          postHaxCodeColor!.map((v) => v.toJson()).toList();
    }
    data['Location'] = location;
    data['Latitude'] = latitude;
    data['City'] = city;
    data['State'] = state;
    data['Country'] = country;
    data['Longitude'] = longitude;
    data['Description'] = description;
    data['mainproductImage'] = mainproductImage;
    if (subproductImage != null) {
      data['subproductImage'] =
          subproductImage!.map((v) => v.toJson()).toList();
    }
    data['isLike'] = isLike;
    data['likeCount'] = likeCount;
    data['commentCount'] = commentCount;
    data['isFavorite'] = isFavorite;
    data['isFollow'] = isFollow;
    data['isView'] = isView;
    if (similarProducts != null) {
      data['SimilarProducts'] =
          similarProducts!.map((v) => v.toJson()).toList();
    }
    data['is_paid_post'] = isPaidPost;
    data['unit_of_price '] = unitOfPrice;
    data['updated_date'] = updatedDate;
    data['created_date'] = createdDate;
    return data;
  }
}

class PostHaxCodeColor {
  String? colorId;
  String? colorName;
  String? haxCode;

  PostHaxCodeColor({this.colorId, this.colorName, this.haxCode});

  PostHaxCodeColor.fromJson(Map<String, dynamic> json) {
    colorId = json['colorId'];
    colorName = json['colorName'];
    haxCode = json['HaxCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['colorId'] = colorId;
    data['colorName'] = colorName;
    data['HaxCode'] = haxCode;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productImageId'] = productImageId;
    data['sub_image_url'] = subImageUrl;
    return data;
  }
}

class SimilarProducts {
  int? productId;
  int? userId;
  String? username;
  String? useremail;
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
  List<PostHaxCodeColor>? postHaxCodeColor;
  String? location;
  String? city;
  String? state;
  String? country;
  String? description;
  String? mainproductImage;
  String? createdDate;

  SimilarProducts(
      {this.productId,
        this.userId,
        this.username,
        this.useremail,
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
        this.postHaxCodeColor,
        this.location,
        this.city,
        this.state,
        this.country,
        this.description,
        this.mainproductImage,
        this.createdDate});

  SimilarProducts.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    userId = json['UserId'];
    username = json['Username'];
    useremail = json['Useremail'];
    postType = json['PostType'];
    categoryId = json['CategoryId'];
    categoryName = json['CategoryName'];
    postName = json['PostName'];
    productTypeId = json['productTypeId'];
    productType = json['ProductType'];
    productGradeId = json['ProductGradeId'];
    productGrade = json['ProductGrade'];
    currency = json['Currency'];
    productPrice = json['ProductPrice'];
    unit = json['Unit'];
    postQuntity = json['PostQuntity'];
    if (json['PostHaxCodeColor'] != null) {
      postHaxCodeColor = <PostHaxCodeColor>[];
      json['PostHaxCodeColor'].forEach((v) {
        postHaxCodeColor!.add(PostHaxCodeColor.fromJson(v));
      });
    }
    location = json['Location'];
    city = json['City'];
    state = json['State'];
    country = json['Country'];
    description = json['Description'];
    mainproductImage = json['mainproductImage'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['UserId'] = userId;
    data['Username'] = username;
    data['Useremail'] = useremail;
    data['PostType'] = postType;
    data['CategoryId'] = categoryId;
    data['CategoryName'] = categoryName;
    data['PostName'] = postName;
    data['productTypeId'] = productTypeId;
    data['ProductType'] = productType;
    data['ProductGradeId'] = productGradeId;
    data['ProductGrade'] = productGrade;
    data['Currency'] = currency;
    data['ProductPrice'] = productPrice;
    data['Unit'] = unit;
    data['PostQuntity'] = postQuntity;
    if (postHaxCodeColor != null) {
      data['PostHaxCodeColor'] =
          postHaxCodeColor!.map((v) => v.toJson()).toList();
    }
    data['Location'] = location;
    data['City'] = city;
    data['State'] = state;
    data['Country'] = country;
    data['Description'] = description;
    data['mainproductImage'] = mainproductImage;
    data['created_date'] = createdDate;
    return data;
  }
}
