class Get_comment {
  int? status;
  String? message;
  List<Data>? data;
  String? commentAvg;
  int? commentCount;
  int? isUerCommented;

  Get_comment(
      {this.status,
        this.message,
        this.data,
        this.commentAvg,
        this.commentCount,
        this.isUerCommented,
      });

  Get_comment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    commentAvg = json['comment_avg'];
    commentCount = json['comment_count'];
    isUerCommented = json['is_user_commented'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['comment_avg'] = this.commentAvg;
    data['comment_count'] = this.commentCount;
    data['is_user_commented'] = this.isUerCommented;
    return data;
  }
}

class Data {
  int? id;
  String? userId;
  String? profileId;
  String? comment;
  String? comImage;
  String? rating;
  String? commentDatetime;
  String? likeCounter;
  String? createdAt;
  String? updatedAt;
  String? userImage;
  String? username;
  String? userImageUrl;
  String? commentImageUrl;
  int? isCommented;
  List<Subcomment>? subcomment;

  Data(
      {this.id,
        this.userId,
        this.profileId,
        this.comment,
        this.comImage,
        this.rating,
        this.commentDatetime,
        this.likeCounter,
        this.createdAt,
        this.updatedAt,
        this.userImage,
        this.username,
        this.userImageUrl,
        this.commentImageUrl,
        this.isCommented,
        this.subcomment});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    profileId = json['profile_id'];
    comment = json['comment'];
    comImage = json['com_image'];
    rating = json['rating'];
    commentDatetime = json['comment_datetime'];
    likeCounter = json['like_counter'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userImage = json['userImage'];
    username = json['username'];
    userImageUrl = json['user_image_url'];
    commentImageUrl = json['comment_image_url'];
    isCommented = json['is_commented'];
    if (json['subcomment'] != null) {
      subcomment = <Subcomment>[];
      json['subcomment'].forEach((v) {
        subcomment!.add(new Subcomment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['profile_id'] = this.profileId;
    data['comment'] = this.comment;
    data['com_image'] = this.comImage;
    data['rating'] = this.rating;
    data['comment_datetime'] = this.commentDatetime;
    data['like_counter'] = this.likeCounter;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['userImage'] = this.userImage;
    data['username'] = this.username;
    data['user_image_url'] = this.userImageUrl;
    data['comment_image_url'] = this.commentImageUrl;
    data['is_commented'] = this.isCommented;
    if (this.subcomment != null) {
      data['subcomment'] = this.subcomment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcomment {
  int? id;
  String? userId;
  String? profileId;
  String? comment;
  int? commentId;
  String? rating;
  String? commentDatetime;
  String? likeCounter;
  String? createdAt;
  String? updatedAt;
  String? userImageUrl;
  User? user;

  Subcomment(
      {this.id,
        this.userId,
        this.profileId,
        this.comment,
        this.commentId,
        this.rating,
        this.commentDatetime,
        this.likeCounter,
        this.createdAt,
        this.updatedAt,
        this.userImageUrl,
        this.user});

  Subcomment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    profileId = json['profile_id'];
    comment = json['comment'];
    commentId = json['comment_id'];
    rating = json['rating'];
    commentDatetime = json['comment_datetime'];
    likeCounter = json['like_counter'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userImageUrl = json['user_image_url'];
    if(json['user'] != null) user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['profile_id'] = this.profileId;
    data['comment'] = this.comment;
    data['comment_id'] = this.commentId;
    data['rating'] = this.rating;
    data['comment_datetime'] = this.commentDatetime;
    data['like_counter'] = this.likeCounter;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_image_url'] = this.userImageUrl;
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
  String? isDirector;
  String? directorStartDate;
  String? directorEndDate;
  String? directorCreatedDate;
  String? deletedAt;
  String? isExhibitor;
  String? exhibitorStartDate;
  String? exhibitorEndDate;
  String? exhibitorCreatedDate;

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
        this.exhibitorCreatedDate});

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
    return data;
  }
}
