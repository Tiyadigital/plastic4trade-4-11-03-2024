// ignore_for_file: prefer_void_to_null, unnecessary_question_mark

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
    json['profile'] != null ?    Profile.fromJson(json['profile']) : null;
    annualTurnover = json['annual_turnover'] != null
        ?    AnnualTurnover.fromJson(json['annual_turnover'])
        : null;
    if (json['doc'] != null) {
      doc = <Doc>[];
      json['doc'].forEach((v) {
        doc!.add(   Doc.fromJson(v));
      });
    }
    user = json['user'] != null ?    User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =    <String, dynamic>{};
    data['status'] =  status;
    if ( profile != null) {
      data['profile'] =  profile!.toJson();
    }
    if ( annualTurnover != null) {
      data['annual_turnover'] =  annualTurnover!.toJson();
    }
    if ( doc != null) {
      data['doc'] =  doc!.map((v) => v.toJson()).toList();
    }
    if ( user != null) {
      data['user'] =  user!.toJson();
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
        ? Annualcapacity.fromJson(json['annualcapacity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] =  id;
    data['user_id'] =  userId;
    data['business_name'] =  businessName;
    data['slug'] =  slug;
    data['business_type'] =  businessType;
    data['gst_tax_vat'] =  gstTaxVat;
    data['product_name'] =  productName;
    data['address'] =  address;
    data['address_line1'] =  addressLine1;
    data['latitude'] =  latitude;
    data['longitude'] =  longitude;
    data['city'] =  city;
    data['state'] =  state;
    data['country'] =  country;
    data['countryCode'] =  countryCode;
    data['business_phone'] =  businessPhone;
    data['other_mobile1'] =  otherMobile1;
    data['other_mobile_code1'] =  otherMobileCode1;
    data['other_mobile2'] =  otherMobile2;
    data['other_mobile_code2'] =  otherMobileCode2;
    data['other_mobile3'] =  otherMobile3;
    data['other_mobile_code3'] =  otherMobileCode3;
    data['other_email'] =  otherEmail;
    data['website'] =  website;
    data['about_business'] =  aboutBusiness;
    data['profilePicture'] =  profilePicture;
    data['registration_date'] = registrationDate;
    data['pan_number'] = panNumber;
    data['export_import_number'] =  exportImportNumber;
    data['production_capacity'] =  productionCapacity;
    data['annual_turnover'] =  annualTurnover;
    data['premises'] =  premises;
    data['document'] =  document;
    data['view_count'] =  viewCount;
    data['like_counter'] =  likeCounter;
    data['instagram_link'] =  instagramLink;
    data['youtube_link'] =  youtubeLink;
    data['facebook_link'] =  facebookLink;
    data['linkedin_link'] =  linkedinLink;
    data['twitter_link'] =  twitterLink;
    data['telegram_link'] =  telegramLink;
    data['created_at'] =  createdAt;
    data['updated_at'] =  updatedAt;
    data['like_count'] =  likeCount;
    data['reviews_count'] =  reviewsCount;
    data['following_count'] =  followingCount;
    data['followers_count'] =  followersCount;
    data['is_follow'] =  isFollow;
    data['business_type_name'] =  businessTypeName;
    data['post_count'] =  postCount;
    if ( annualcapacity != null) {
      data['annualcapacity'] =  annualcapacity!.toJson();
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
    final Map<String, dynamic> data =    <String, dynamic>{};
    data['id'] =  id;
    data['name'] =  name;
    data['created_at'] =  createdAt;
    data['deleted_at'] =  deletedAt;
    data['updated_at'] =  updatedAt;
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
        ?    Amounts2021.fromJson(json['amounts2021'])
        : null;
    amounts2122 = json['amounts2122'] != null
        ?    Amounts2021.fromJson(json['amounts2122'])
        : null;
    amounts2223 = json['amounts2223'] != null
        ?    Amounts2021.fromJson(json['amounts2223'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =    <String, dynamic>{};
    data['id'] =  id;
    data['user_id'] =  userId;
    data['business_id'] =  businessId;
    data['currency_20_21'] =  currency2021;
    data['amount_20_21'] =  amount2021;
    data['currency_21_22'] =  currency2122;
    data['amount_21_22'] =  amount2122;
    data['currency_22_23'] =  currency2223;
    data['amount_22_23'] =  amount2223;
    data['created_at'] =  createdAt;
    data['updated_at'] =  updatedAt;
    data['deleted_at'] =  deletedAt;
    if ( amounts2021 != null) {
      data['amounts2021'] =  amounts2021!.toJson();
    }
    if ( amounts2122 != null) {
      data['amounts2122'] =  amounts2122!.toJson();
    }
    if ( amounts2223 != null) {
      data['amounts2223'] =  amounts2223!.toJson();
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
    final Map<String, dynamic> data =    <String, dynamic>{};
    data['id'] =  id;
    data['name'] =  name;
    data['created_at'] =  createdAt;
    data['updated_at'] =  updatedAt;
    data['deleted_at'] =  deletedAt;
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
        ?    Amounts2021.fromJson(json['doctype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] =  id;
    data['doc_type'] =  docType;
    data['document'] =  document;
    data['user_id'] =  userId;
    data['business_id'] =  businessId;
    data['created_at'] =  createdAt;
    data['updated_at'] =  updatedAt;
    data['deleted_at'] =  deletedAt;
    data['document_url'] =  documentUrl;
    if ( doctype != null) {
      data['doctype'] =  doctype!.toJson();
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
    final Map<String, dynamic> data =    <String, dynamic>{};
    data['id'] =  id;
    data['username'] =  username;
    data['email'] =  email;
    data['password'] =  password;
    data['countryCode'] =  countryCode;
    data['device'] =  device;
    data['phoneno'] =  phoneno;
    data['userImage'] =  userImage;
    data['userToken'] =  userToken;
    data['signup_date'] =  signupDate;
    data['is_block'] =  isBlock;
    data['blockDate'] =  blockDate;
    data['register_status'] =  registerStatus;
    data['created_at'] =  createdAt;
    data['updated_at'] =  updatedAt;
    data['email_code'] =  emailCode;
    data['emailCodeDateTime'] =  emailCodeDateTime;
    data['sms_code'] =  smsCode;
    data['smsCodeDateTime'] =  smsCodeDateTime;
    data['forgotpasswordDateTime'] =  forgotpasswordDateTime;
    data['verify_email'] =  verifyEmail;
    data['verify_sms'] =  verifySms;
    data['category_id'] =  categoryId;
    data['type_id'] =  typeId;
    data['grade_id'] =  gradeId;
    data['step_counter'] =  stepCounter;
    data['posttype'] =  posttype;
    data['location_interest'] =  locationInterest;
    data['coverImage'] =  coverImage;
    data['is_director'] =  isDirector;
    data['director_start_date'] =  directorStartDate;
    data['director_end_date'] =  directorEndDate;
    data['director_created_date'] =  directorCreatedDate;
    data['deleted_at'] =  deletedAt;
    data['is_exhibitor'] =  isExhibitor;
    data['exhibitor_start_date'] =  exhibitorStartDate;
    data['exhibitor_end_date'] =  exhibitorEndDate;
    data['exhibitor_created_date'] =  exhibitorCreatedDate;
    data['image_url'] =  imageUrl;
    data['category_name'] =  categoryName;
    return data;
  }
}
