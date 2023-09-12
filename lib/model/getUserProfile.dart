class getUserProfile {
  int? status;
  User? user;

  getUserProfile({this.status, this.user});

  getUserProfile.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
  String? blockDate;
  String? registerStatus;
  String? createdAt;
  String? updatedAt;
  String? emailCode;
  String? emailCodeDateTime;
  String? smsCode;
  String? smsCodeDateTime;
  String? forgotpasswordDateTime;
  String? verifyEmail;
  String? verifySms;
  String? categoryId;
  String? typeId;
  String? gradeId;
  int? stepCounter;
  String? posttype;
  String? locationInterest;
  String? coverImage;
  Null? deletedAt;
  String? imageUrl;

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
        this.deletedAt,
        this.imageUrl});

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
    deletedAt = json['deleted_at'];
    imageUrl = json['image_url'];
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
    data['deleted_at'] = this.deletedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
