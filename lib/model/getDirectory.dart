// ignore_for_file: camel_case_types

class getDirectory {
  int? _status;
  String? _message;
  List<Result>? _result;

  getDirectory({int? status, String? message, List<Result>? result}) {
    if (status != null) {
      _status = status;
    }
    if (message != null) {
      _message = message;
    }
    if (result != null) {
      _result = result;
    }
  }

  int? get status => _status;
  set status(int? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Result>? get result => _result;
  set result(List<Result>? result) => _result = result;

  getDirectory.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    if (json['result'] != null) {
      _result = <Result>[];
      json['result'].forEach((v) {
        _result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = _status;
    data['message'] = _message;
    if (_result != null) {
      data['result'] = _result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? _id;
  String? _username;
  String? _email;
  String? _password;
  String? _countryCode;
  String? _device;
  String? _phoneno;
  String? _userImage;
  String? _userToken;
  String? _signupDate;
  String? _isBlock;
  Null? _blockDate;
  String? _registerStatus;
  String? _createdAt;
  String? _updatedAt;
  String? _emailCode;
  String? _emailCodeDateTime;
  String? _smsCode;
  String? _smsCodeDateTime;
  Null? _forgotpasswordDateTime;
  String? _verifyEmail;
  String? _verifySms;
  String? _categoryId;
  String? _typeId;
  String? _gradeId;
  int? _stepCounter;
  String? _posttype;
  String? _locationInterest;
  String? _coverImage;
  String? _isDirector;
  String? _directorStartDate;
  String? _directorEndDate;
  String? _directorCreatedDate;
  Null? _deletedAt;
  String? _isExhibitor;
  String? _exhibitorStartDate;
  String? _exhibitorEndDate;
  String? _exhibitorCreatedDate;
  List<String>? _businessType;
  String? _address;
  List<String>? _productName;
  String? _userImageUrl;

  Result(
      {int? id,
        String? username,
        String? email,
        String? password,
        String? countryCode,
        String? device,
        String? phoneno,
        String? userImage,
        String? userToken,
        String? signupDate,
        String? isBlock,
        Null? blockDate,
        String? registerStatus,
        String? createdAt,
        String? updatedAt,
        String? emailCode,
        String? emailCodeDateTime,
        String? smsCode,
        String? smsCodeDateTime,
        Null? forgotpasswordDateTime,
        String? verifyEmail,
        String? verifySms,
        String? categoryId,
        String? typeId,
        String? gradeId,
        int? stepCounter,
        String? posttype,
        String? locationInterest,
        String? coverImage,
        String? isDirector,
        String? directorStartDate,
        String? directorEndDate,
        String? directorCreatedDate,
        Null? deletedAt,
        String? isExhibitor,
        String? exhibitorStartDate,
        String? exhibitorEndDate,
        String? exhibitorCreatedDate,
        List<String>? businessType,
        String? address,
        List<String>? productName,
        String? userImageUrl}) {
    if (id != null) {
      _id = id;
    }
    if (username != null) {
      _username = username;
    }
    if (email != null) {
      _email = email;
    }
    if (password != null) {
      _password = password;
    }
    if (countryCode != null) {
      _countryCode = countryCode;
    }
    if (device != null) {
      _device = device;
    }
    if (phoneno != null) {
      _phoneno = phoneno;
    }
    if (userImage != null) {
      _userImage = userImage;
    }
    if (userToken != null) {
      _userToken = userToken;
    }
    if (signupDate != null) {
      _signupDate = signupDate;
    }
    if (isBlock != null) {
      _isBlock = isBlock;
    }
    if (blockDate != null) {
      _blockDate = blockDate;
    }
    if (registerStatus != null) {
      _registerStatus = registerStatus;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (emailCode != null) {
      _emailCode = emailCode;
    }
    if (emailCodeDateTime != null) {
      _emailCodeDateTime = emailCodeDateTime;
    }
    if (smsCode != null) {
      _smsCode = smsCode;
    }
    if (smsCodeDateTime != null) {
      _smsCodeDateTime = smsCodeDateTime;
    }
    if (forgotpasswordDateTime != null) {
      _forgotpasswordDateTime = forgotpasswordDateTime;
    }
    if (verifyEmail != null) {
      _verifyEmail = verifyEmail;
    }
    if (verifySms != null) {
      _verifySms = verifySms;
    }
    if (categoryId != null) {
      _categoryId = categoryId;
    }
    if (typeId != null) {
      _typeId = typeId;
    }
    if (gradeId != null) {
      _gradeId = gradeId;
    }
    if (stepCounter != null) {
      _stepCounter = stepCounter;
    }
    if (posttype != null) {
      _posttype = posttype;
    }
    if (locationInterest != null) {
      _locationInterest = locationInterest;
    }
    if (coverImage != null) {
      _coverImage = coverImage;
    }
    if (isDirector != null) {
      _isDirector = isDirector;
    }
    if (directorStartDate != null) {
      _directorStartDate = directorStartDate;
    }
    if (directorEndDate != null) {
      _directorEndDate = directorEndDate;
    }
    if (directorCreatedDate != null) {
      _directorCreatedDate = directorCreatedDate;
    }
    if (deletedAt != null) {
      _deletedAt = deletedAt;
    }
    if (isExhibitor != null) {
      _isExhibitor = isExhibitor;
    }
    if (exhibitorStartDate != null) {
      _exhibitorStartDate = exhibitorStartDate;
    }
    if (exhibitorEndDate != null) {
      _exhibitorEndDate = exhibitorEndDate;
    }
    if (exhibitorCreatedDate != null) {
      _exhibitorCreatedDate = exhibitorCreatedDate;
    }
    if (businessType != null) {
      _businessType = businessType;
    }
    if (address != null) {
      _address = address;
    }
    if (productName != null) {
      _productName = productName;
    }
    if (userImageUrl != null) {
      _userImageUrl = userImageUrl;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get username => _username;
  set username(String? username) => _username = username;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get countryCode => _countryCode;
  set countryCode(String? countryCode) => _countryCode = countryCode;
  String? get device => _device;
  set device(String? device) => _device = device;
  String? get phoneno => _phoneno;
  set phoneno(String? phoneno) => _phoneno = phoneno;
  String? get userImage => _userImage;
  set userImage(String? userImage) => _userImage = userImage;
  String? get userToken => _userToken;
  set userToken(String? userToken) => _userToken = userToken;
  String? get signupDate => _signupDate;
  set signupDate(String? signupDate) => _signupDate = signupDate;
  String? get isBlock => _isBlock;
  set isBlock(String? isBlock) => _isBlock = isBlock;
  Null? get blockDate => _blockDate;
  set blockDate(Null? blockDate) => _blockDate = blockDate;
  String? get registerStatus => _registerStatus;
  set registerStatus(String? registerStatus) =>
      _registerStatus = registerStatus;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get emailCode => _emailCode;
  set emailCode(String? emailCode) => _emailCode = emailCode;
  String? get emailCodeDateTime => _emailCodeDateTime;
  set emailCodeDateTime(String? emailCodeDateTime) =>
      _emailCodeDateTime = emailCodeDateTime;
  String? get smsCode => _smsCode;
  set smsCode(String? smsCode) => _smsCode = smsCode;
  String? get smsCodeDateTime => _smsCodeDateTime;
  set smsCodeDateTime(String? smsCodeDateTime) =>
      _smsCodeDateTime = smsCodeDateTime;
  Null? get forgotpasswordDateTime => _forgotpasswordDateTime;
  set forgotpasswordDateTime(Null? forgotpasswordDateTime) =>
      _forgotpasswordDateTime = forgotpasswordDateTime;
  String? get verifyEmail => _verifyEmail;
  set verifyEmail(String? verifyEmail) => _verifyEmail = verifyEmail;
  String? get verifySms => _verifySms;
  set verifySms(String? verifySms) => _verifySms = verifySms;
  String? get categoryId => _categoryId;
  set categoryId(String? categoryId) => _categoryId = categoryId;
  String? get typeId => _typeId;
  set typeId(String? typeId) => _typeId = typeId;
  String? get gradeId => _gradeId;
  set gradeId(String? gradeId) => _gradeId = gradeId;
  int? get stepCounter => _stepCounter;
  set stepCounter(int? stepCounter) => _stepCounter = stepCounter;
  String? get posttype => _posttype;
  set posttype(String? posttype) => _posttype = posttype;
  String? get locationInterest => _locationInterest;
  set locationInterest(String? locationInterest) =>
      _locationInterest = locationInterest;
  String? get coverImage => _coverImage;
  set coverImage(String? coverImage) => _coverImage = coverImage;
  String? get isDirector => _isDirector;
  set isDirector(String? isDirector) => _isDirector = isDirector;
  String? get directorStartDate => _directorStartDate;
  set directorStartDate(String? directorStartDate) =>
      _directorStartDate = directorStartDate;
  String? get directorEndDate => _directorEndDate;
  set directorEndDate(String? directorEndDate) =>
      _directorEndDate = directorEndDate;
  String? get directorCreatedDate => _directorCreatedDate;
  set directorCreatedDate(String? directorCreatedDate) =>
      _directorCreatedDate = directorCreatedDate;
  Null? get deletedAt => _deletedAt;
  set deletedAt(Null? deletedAt) => _deletedAt = deletedAt;
  String? get isExhibitor => _isExhibitor;
  set isExhibitor(String? isExhibitor) => _isExhibitor = isExhibitor;
  String? get exhibitorStartDate => _exhibitorStartDate;
  set exhibitorStartDate(String? exhibitorStartDate) =>
      _exhibitorStartDate = exhibitorStartDate;
  String? get exhibitorEndDate => _exhibitorEndDate;
  set exhibitorEndDate(String? exhibitorEndDate) =>
      _exhibitorEndDate = exhibitorEndDate;
  String? get exhibitorCreatedDate => _exhibitorCreatedDate;
  set exhibitorCreatedDate(String? exhibitorCreatedDate) =>
      _exhibitorCreatedDate = exhibitorCreatedDate;
  List<String>? get businessType => _businessType;
  set businessType(List<String>? businessType) => _businessType = businessType;
  String? get address => _address;
  set address(String? address) => _address = address;
  List<String>? get productName => _productName;
  set productName(List<String>? productName) => _productName = productName;
  String? get userImageUrl => _userImageUrl;
  set userImageUrl(String? userImageUrl) => _userImageUrl = userImageUrl;

  Result.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _username = json['username'];
    _email = json['email'];
    _password = json['password'];
    _countryCode = json['countryCode'];
    _device = json['device'];
    _phoneno = json['phoneno'];
    _userImage = json['userImage'];
    _userToken = json['userToken'];
    _signupDate = json['signup_date'];
    _isBlock = json['is_block'];
    _blockDate = json['blockDate'];
    _registerStatus = json['register_status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _emailCode = json['email_code'];
    _emailCodeDateTime = json['emailCodeDateTime'];
    _smsCode = json['sms_code'];
    _smsCodeDateTime = json['smsCodeDateTime'];
    _forgotpasswordDateTime = json['forgotpasswordDateTime'];
    _verifyEmail = json['verify_email'];
    _verifySms = json['verify_sms'];
    _categoryId = json['category_id'];
    _typeId = json['type_id'];
    _gradeId = json['grade_id'];
    _stepCounter = json['step_counter'];
    _posttype = json['posttype'];
    _locationInterest = json['location_interest'];
    _coverImage = json['coverImage'];
    _isDirector = json['is_director'];
    _directorStartDate = json['director_start_date'];
    _directorEndDate = json['director_end_date'];
    _directorCreatedDate = json['director_created_date'];
    _deletedAt = json['deleted_at'];
    _isExhibitor = json['is_exhibitor'];
    _exhibitorStartDate = json['exhibitor_start_date'];
    _exhibitorEndDate = json['exhibitor_end_date'];
    _exhibitorCreatedDate = json['exhibitor_created_date'];
    _businessType = json['business_type'].cast<String>();
    _address = json['address'];
    _productName = json['product_name'].cast<String>();
    _userImageUrl = json['user_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = _id;
    data['username'] = _username;
    data['email'] = _email;
    data['password'] = _password;
    data['countryCode'] = _countryCode;
    data['device'] = _device;
    data['phoneno'] = _phoneno;
    data['userImage'] = _userImage;
    data['userToken'] = _userToken;
    data['signup_date'] = _signupDate;
    data['is_block'] = _isBlock;
    data['blockDate'] = _blockDate;
    data['register_status'] = _registerStatus;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['email_code'] = _emailCode;
    data['emailCodeDateTime'] = _emailCodeDateTime;
    data['sms_code'] = _smsCode;
    data['smsCodeDateTime'] = _smsCodeDateTime;
    data['forgotpasswordDateTime'] = _forgotpasswordDateTime;
    data['verify_email'] = _verifyEmail;
    data['verify_sms'] = _verifySms;
    data['category_id'] = _categoryId;
    data['type_id'] = _typeId;
    data['grade_id'] = _gradeId;
    data['step_counter'] = _stepCounter;
    data['posttype'] = _posttype;
    data['location_interest'] = _locationInterest;
    data['coverImage'] = _coverImage;
    data['is_director'] = _isDirector;
    data['director_start_date'] = _directorStartDate;
    data['director_end_date'] = _directorEndDate;
    data['director_created_date'] = _directorCreatedDate;
    data['deleted_at'] = _deletedAt;
    data['is_exhibitor'] = _isExhibitor;
    data['exhibitor_start_date'] = _exhibitorStartDate;
    data['exhibitor_end_date'] = _exhibitorEndDate;
    data['exhibitor_created_date'] = _exhibitorCreatedDate;
    data['business_type'] = _businessType;
    data['address'] = _address;
    data['product_name'] = _productName;
    data['user_image_url'] = _userImageUrl;
    return data;
  }
}
