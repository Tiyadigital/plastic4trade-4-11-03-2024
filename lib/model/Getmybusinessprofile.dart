class Getmybusinessprofile {
  int? status;
  Profile? profile;
  AnnualTurnover? annualTurnover;
  List<Doc>? doc;
  User? user;

  Getmybusinessprofile(
      {this.status, this.profile, this.annualTurnover, this.doc, this.user});

  Getmybusinessprofile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    annualTurnover = json['annual_turnover'] != null
        ? new AnnualTurnover.fromJson(json['annual_turnover'])
        : null;
    if (json['doc'] != null) {
      doc = <Doc>[];
      json['doc'].forEach((v) {
        doc!.add(new Doc.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.annualTurnover != null) {
      data['annual_turnover'] = this.annualTurnover!.toJson();
    }
    if (this.doc != null) {
      data['doc'] = this.doc!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? userId;
  String? businessName;
  String? slug;
  String? businessType;
  String? gstTaxVat;
  String? productName;
  String? address;
  Null? addressLine1;
  String? latitude;
  String? longitude;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  String? businessPhone;
  String? otherMobile1;
  String? otherMobileCode1;
  String? otherMobile2;
  String? otherMobileCode2;
  String? otherMobile3;
  String? otherMobileCode3;
  String? otherEmail;
  String? website;
  String? aboutBusiness;
  String? profilePicture;
  String? registrationDate;
  String? panNumber;
  String? exportImportNumber;
  String? productionCapacity;
  Null? annualTurnover;
  String? premises;
  Null? document;
  int? viewCount;
  String? likeCounter;
  String? instagramLink;
  String? youtubeLink;
  Null? facebookLink;
  Null? linkedinLink;
  String? twitterLink;
  Null? telegramLink;
  String? createdAt;
  String? updatedAt;
  int? likeCount;
  int? reviewsCount;
  int? followingCount;
  int? followersCount;
  String? isFollow;
  String? businessTypeName;
  int? postCount;
  Annualcapacity? annualcapacity;

  Profile(
      {this.id,
        this.userId,
        this.businessName,
        this.slug,
        this.businessType,
        this.gstTaxVat,
        this.productName,
        this.address,
        this.addressLine1,
        this.latitude,
        this.longitude,
        this.city,
        this.state,
        this.country,
        this.countryCode,
        this.businessPhone,
        this.otherMobile1,
        this.otherMobileCode1,
        this.otherMobile2,
        this.otherMobileCode2,
        this.otherMobile3,
        this.otherMobileCode3,
        this.otherEmail,
        this.website,
        this.aboutBusiness,
        this.profilePicture,
        this.registrationDate,
        this.panNumber,
        this.exportImportNumber,
        this.productionCapacity,
        this.annualTurnover,
        this.premises,
        this.document,
        this.viewCount,
        this.likeCounter,
        this.instagramLink,
        this.youtubeLink,
        this.facebookLink,
        this.linkedinLink,
        this.twitterLink,
        this.telegramLink,
        this.createdAt,
        this.updatedAt,
        this.likeCount,
        this.reviewsCount,
        this.followingCount,
        this.followersCount,
        this.isFollow,
        this.businessTypeName,
        this.postCount,
        this.annualcapacity});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    businessName = json['business_name'];
    slug = json['slug'];
    businessType = json['business_type'];
    gstTaxVat = json['gst_tax_vat'];
    productName = json['product_name'];
    address = json['address'];
    addressLine1 = json['address_line1'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    countryCode = json['countryCode'];
    businessPhone = json['business_phone'];
    otherMobile1 = json['other_mobile1'];
    otherMobileCode1 = json['other_mobile_code1'];
    otherMobile2 = json['other_mobile2'];
    otherMobileCode2 = json['other_mobile_code2'];
    otherMobile3 = json['other_mobile3'];
    otherMobileCode3 = json['other_mobile_code3'];
    otherEmail = json['other_email'];
    website = json['website'];
    aboutBusiness = json['about_business'];
    profilePicture = json['profilePicture'];
    registrationDate = json['registration_date'];
    panNumber = json['pan_number'];
    exportImportNumber = json['export_import_number'];
    productionCapacity = json['production_capacity'];
    annualTurnover = json['annual_turnover'];
    premises = json['premises'];
    document = json['document'];
    viewCount = json['view_count'];
    likeCounter = json['like_counter'];
    instagramLink = json['instagram_link'];
    youtubeLink = json['youtube_link'];
    facebookLink = json['facebook_link'];
    linkedinLink = json['linkedin_link'];
    twitterLink = json['twitter_link'];
    telegramLink = json['telegram_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likeCount = json['like_count'];
    reviewsCount = json['reviews_count'];
    followingCount = json['following_count'];
    followersCount = json['followers_count'];
    isFollow = json['is_follow'];
    businessTypeName = json['business_type_name'];
    postCount = json['post_count'];
    annualcapacity = json['annualcapacity'] != null
        ? new Annualcapacity.fromJson(json['annualcapacity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['business_name'] = this.businessName;
    data['slug'] = this.slug;
    data['business_type'] = this.businessType;
    data['gst_tax_vat'] = this.gstTaxVat;
    data['product_name'] = this.productName;
    data['address'] = this.address;
    data['address_line1'] = this.addressLine1;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    data['business_phone'] = this.businessPhone;
    data['other_mobile1'] = this.otherMobile1;
    data['other_mobile_code1'] = this.otherMobileCode1;
    data['other_mobile2'] = this.otherMobile2;
    data['other_mobile_code2'] = this.otherMobileCode2;
    data['other_mobile3'] = this.otherMobile3;
    data['other_mobile_code3'] = this.otherMobileCode3;
    data['other_email'] = this.otherEmail;
    data['website'] = this.website;
    data['about_business'] = this.aboutBusiness;
    data['profilePicture'] = this.profilePicture;
    data['registration_date'] = this.registrationDate;
    data['pan_number'] = this.panNumber;
    data['export_import_number'] = this.exportImportNumber;
    data['production_capacity'] = this.productionCapacity;
    data['annual_turnover'] = this.annualTurnover;
    data['premises'] = this.premises;
    data['document'] = this.document;
    data['view_count'] = this.viewCount;
    data['like_counter'] = this.likeCounter;
    data['instagram_link'] = this.instagramLink;
    data['youtube_link'] = this.youtubeLink;
    data['facebook_link'] = this.facebookLink;
    data['linkedin_link'] = this.linkedinLink;
    data['twitter_link'] = this.twitterLink;
    data['telegram_link'] = this.telegramLink;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['like_count'] = this.likeCount;
    data['reviews_count'] = this.reviewsCount;
    data['following_count'] = this.followingCount;
    data['followers_count'] = this.followersCount;
    data['is_follow'] = this.isFollow;
    data['business_type_name'] = this.businessTypeName;
    data['post_count'] = this.postCount;
    if (this.annualcapacity != null) {
      data['annualcapacity'] = this.annualcapacity!.toJson();
    }
    return data;
  }
}

class Annualcapacity {
  int? id;
  String? name;
  String? createdAt;
  String? deletedAt;
  Null? updatedAt;

  Annualcapacity(
      {this.id, this.name, this.createdAt, this.deletedAt, this.updatedAt});

  Annualcapacity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AnnualTurnover {
  int? id;
  int? userId;
  int? businessId;
  String? currency2021;
  String? amount2021;
  String? currency2122;
  String? amount2122;
  String? currency2223;
  String? amount2223;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Amounts2021? amounts2021;
  Amounts2021? amounts2122;
  Amounts2021? amounts2223;

  AnnualTurnover(
      {this.id,
        this.userId,
        this.businessId,
        this.currency2021,
        this.amount2021,
        this.currency2122,
        this.amount2122,
        this.currency2223,
        this.amount2223,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.amounts2021,
        this.amounts2122,
        this.amounts2223});

  AnnualTurnover.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    businessId = json['business_id'];
    currency2021 = json['currency_20_21'];
    amount2021 = json['amount_20_21'];
    currency2122 = json['currency_21_22'];
    amount2122 = json['amount_21_22'];
    currency2223 = json['currency_22_23'];
    amount2223 = json['amount_22_23'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    amounts2021 = json['amounts2021'] != null
        ? new Amounts2021.fromJson(json['amounts2021'])
        : null;
    amounts2122 = json['amounts2122'] != null
        ? new Amounts2021.fromJson(json['amounts2122'])
        : null;
    amounts2223 = json['amounts2223'] != null
        ? new Amounts2021.fromJson(json['amounts2223'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['business_id'] = this.businessId;
    data['currency_20_21'] = this.currency2021;
    data['amount_20_21'] = this.amount2021;
    data['currency_21_22'] = this.currency2122;
    data['amount_21_22'] = this.amount2122;
    data['currency_22_23'] = this.currency2223;
    data['amount_22_23'] = this.amount2223;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.amounts2021 != null) {
      data['amounts2021'] = this.amounts2021!.toJson();
    }
    if (this.amounts2122 != null) {
      data['amounts2122'] = this.amounts2122!.toJson();
    }
    if (this.amounts2223 != null) {
      data['amounts2223'] = this.amounts2223!.toJson();
    }
    return data;
  }
}

class Amounts2021 {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Amounts2021(
      {this.id, this.name, this.createdAt, this.updatedAt, this.deletedAt});

  Amounts2021.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Doc {
  int? id;
  String? docType;
  String? document;
  int? userId;
  int? businessId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? documentUrl;
  Amounts2021? doctype;

  Doc(
      {this.id,
        this.docType,
        this.document,
        this.userId,
        this.businessId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.documentUrl,
        this.doctype});

  Doc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docType = json['doc_type'];
    document = json['document'];
    userId = json['user_id'];
    businessId = json['business_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    documentUrl = json['document_url'];
    doctype = json['doctype'] != null
        ? new Amounts2021.fromJson(json['doctype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doc_type'] = this.docType;
    data['document'] = this.document;
    data['user_id'] = this.userId;
    data['business_id'] = this.businessId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['document_url'] = this.documentUrl;
    if (this.doctype != null) {
      data['doctype'] = this.doctype!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? password;
  String? countryCode;
  String? device;
  String? phoneno;
  String? userImage;
  String? userToken;
  String? signupDate;
  String? isBlock;
  Null? blockDate;
  String? registerStatus;
  String? createdAt;
  String? updatedAt;
  String? emailCode;
  String? emailCodeDateTime;
  String? smsCode;
  String? smsCodeDateTime;
  Null? forgotpasswordDateTime;
  String? verifyEmail;
  String? verifySms;
  String? categoryId;
  String? typeId;
  String? gradeId;
  int? stepCounter;
  String? posttype;
  String? locationInterest;
  String? coverImage;
  String? isDirector;
  String? directorStartDate;
  String? directorEndDate;
  String? directorCreatedDate;
  Null? deletedAt;
  String? isExhibitor;
  String? exhibitorStartDate;
  String? exhibitorEndDate;
  String? exhibitorCreatedDate;
  String? imageUrl;
  String? categoryName;

  User(
      {this.id,
        this.username,
        this.email,
        this.password,
        this.countryCode,
        this.device,
        this.phoneno,
        this.userImage,
        this.userToken,
        this.signupDate,
        this.isBlock,
        this.blockDate,
        this.registerStatus,
        this.createdAt,
        this.updatedAt,
        this.emailCode,
        this.emailCodeDateTime,
        this.smsCode,
        this.smsCodeDateTime,
        this.forgotpasswordDateTime,
        this.verifyEmail,
        this.verifySms,
        this.categoryId,
        this.typeId,
        this.gradeId,
        this.stepCounter,
        this.posttype,
        this.locationInterest,
        this.coverImage,
        this.isDirector,
        this.directorStartDate,
        this.directorEndDate,
        this.directorCreatedDate,
        this.deletedAt,
        this.isExhibitor,
        this.exhibitorStartDate,
        this.exhibitorEndDate,
        this.exhibitorCreatedDate,
        this.imageUrl,
        this.categoryName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    countryCode = json['countryCode'];
    device = json['device'];
    phoneno = json['phoneno'];
    userImage = json['userImage'];
    userToken = json['userToken'];
    signupDate = json['signup_date'];
    isBlock = json['is_block'];
    blockDate = json['blockDate'];
    registerStatus = json['register_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailCode = json['email_code'];
    emailCodeDateTime = json['emailCodeDateTime'];
    smsCode = json['sms_code'];
    smsCodeDateTime = json['smsCodeDateTime'];
    forgotpasswordDateTime = json['forgotpasswordDateTime'];
    verifyEmail = json['verify_email'];
    verifySms = json['verify_sms'];
    categoryId = json['category_id'];
    typeId = json['type_id'];
    gradeId = json['grade_id'];
    stepCounter = json['step_counter'];
    posttype = json['posttype'];
    locationInterest = json['location_interest'];
    coverImage = json['coverImage'];
    isDirector = json['is_director'];
    directorStartDate = json['director_start_date'];
    directorEndDate = json['director_end_date'];
    directorCreatedDate = json['director_created_date'];
    deletedAt = json['deleted_at'];
    isExhibitor = json['is_exhibitor'];
    exhibitorStartDate = json['exhibitor_start_date'];
    exhibitorEndDate = json['exhibitor_end_date'];
    exhibitorCreatedDate = json['exhibitor_created_date'];
    imageUrl = json['image_url'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['countryCode'] = this.countryCode;
    data['device'] = this.device;
    data['phoneno'] = this.phoneno;
    data['userImage'] = this.userImage;
    data['userToken'] = this.userToken;
    data['signup_date'] = this.signupDate;
    data['is_block'] = this.isBlock;
    data['blockDate'] = this.blockDate;
    data['register_status'] = this.registerStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email_code'] = this.emailCode;
    data['emailCodeDateTime'] = this.emailCodeDateTime;
    data['sms_code'] = this.smsCode;
    data['smsCodeDateTime'] = this.smsCodeDateTime;
    data['forgotpasswordDateTime'] = this.forgotpasswordDateTime;
    data['verify_email'] = this.verifyEmail;
    data['verify_sms'] = this.verifySms;
    data['category_id'] = this.categoryId;
    data['type_id'] = this.typeId;
    data['grade_id'] = this.gradeId;
    data['step_counter'] = this.stepCounter;
    data['posttype'] = this.posttype;
    data['location_interest'] = this.locationInterest;
    data['coverImage'] = this.coverImage;
    data['is_director'] = this.isDirector;
    data['director_start_date'] = this.directorStartDate;
    data['director_end_date'] = this.directorEndDate;
    data['director_created_date'] = this.directorCreatedDate;
    data['deleted_at'] = this.deletedAt;
    data['is_exhibitor'] = this.isExhibitor;
    data['exhibitor_start_date'] = this.exhibitorStartDate;
    data['exhibitor_end_date'] = this.exhibitorEndDate;
    data['exhibitor_created_date'] = this.exhibitorCreatedDate;
    data['image_url'] = this.imageUrl;
    data['category_name'] = this.categoryName;
    return data;
  }
}
