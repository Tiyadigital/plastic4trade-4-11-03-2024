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
  Null? unitOfPrice;
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
        postHaxCodeColor!.add(new PostHaxCodeColor.fromJson(v));
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
        subproductImage!.add(new SubproductImage.fromJson(v));
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
        similarProducts!.add(new SimilarProducts.fromJson(v));
      });
    }
    isPaidPost = json['is_paid_post'];
    unitOfPrice = json['unit_of_price '];
    updatedDate = json['updated_date'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['UserId'] = this.userId;
    data['Username'] = this.username;
    data['BusinessType'] = this.businessType;
    data['UserImage'] = this.userImage;
    data['PostType'] = this.postType;
    data['CategoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    data['PostName'] = this.postName;
    data['productTypeId'] = this.productTypeId;
    data['ProductType'] = this.productType;
    data['ProductGradeId'] = this.productGradeId;
    data['ProductGrade'] = this.productGrade;
    data['Currency'] = this.currency;
    data['ProductPrice'] = this.productPrice;
    data['Unit'] = this.unit;
    data['PostQuntity'] = this.postQuntity;
    if (this.postHaxCodeColor != null) {
      data['PostHaxCodeColor'] =
          this.postHaxCodeColor!.map((v) => v.toJson()).toList();
    }
    data['Location'] = this.location;
    data['Latitude'] = this.latitude;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Country'] = this.country;
    data['Longitude'] = this.longitude;
    data['Description'] = this.description;
    data['mainproductImage'] = this.mainproductImage;
    if (this.subproductImage != null) {
      data['subproductImage'] =
          this.subproductImage!.map((v) => v.toJson()).toList();
    }
    data['isLike'] = this.isLike;
    data['likeCount'] = this.likeCount;
    data['commentCount'] = this.commentCount;
    data['isFavorite'] = this.isFavorite;
    data['isFollow'] = this.isFollow;
    data['isView'] = this.isView;
    if (this.similarProducts != null) {
      data['SimilarProducts'] =
          this.similarProducts!.map((v) => v.toJson()).toList();
    }
    data['is_paid_post'] = this.isPaidPost;
    data['unit_of_price '] = this.unitOfPrice;
    data['updated_date'] = this.updatedDate;
    data['created_date'] = this.createdDate;
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
        postHaxCodeColor!.add(new PostHaxCodeColor.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['UserId'] = this.userId;
    data['Username'] = this.username;
    data['Useremail'] = this.useremail;
    data['PostType'] = this.postType;
    data['CategoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    data['PostName'] = this.postName;
    data['productTypeId'] = this.productTypeId;
    data['ProductType'] = this.productType;
    data['ProductGradeId'] = this.productGradeId;
    data['ProductGrade'] = this.productGrade;
    data['Currency'] = this.currency;
    data['ProductPrice'] = this.productPrice;
    data['Unit'] = this.unit;
    data['PostQuntity'] = this.postQuntity;
    if (this.postHaxCodeColor != null) {
      data['PostHaxCodeColor'] =
          this.postHaxCodeColor!.map((v) => v.toJson()).toList();
    }
    data['Location'] = this.location;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Country'] = this.country;
    data['Description'] = this.description;
    data['mainproductImage'] = this.mainproductImage;
    data['created_date'] = this.createdDate;
    return data;
  }
}
