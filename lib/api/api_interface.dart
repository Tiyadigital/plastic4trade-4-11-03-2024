import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:Plastic4trade/utill/constant.dart';

String baseurl = 'https://www.plastic4trade.com/api/';

// Login
Future login_user(String devicenm, String mbl, String password) async {
  String loginUrl = 'login';
  var res;

  final response = await http.post(Uri.parse(baseurl + loginUrl),
      headers: {"Accept": "application/json"},
      body: {'device': devicenm, 'email': mbl, 'password': password});

  print(response.statusCode);
  print(mbl);
  print(password);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future androidDevice_Register(String mbl) async {
  String loginUrl = 'androidDeviceRegister';
  var res;

  print('fcm ${constanst.fcm_token}');
  final response = await http.post(Uri.parse(baseurl + loginUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'regId': constanst.fcm_token,
    'device_id': constanst.android_device_id,
    'user_id': constanst.userid,
    'email': mbl
  });

  print(response.statusCode);
  print(response.body);
  print(mbl);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future iosDevice_Register() async {
  String loginUrl = 'iosDeviceRegister';
  var res;

  print('fcm ${constanst.APNSToken}');
  final response = await http.post(Uri.parse(baseurl + loginUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'user_id': constanst.userid,
    'deviceuid': constanst.ios_device_id,
    'devicetoken': constanst.APNSToken,
    'devicename': constanst.devicename,
    'push_notification_status': '1'
  });

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future android_logout(deviceid) async {
  String loginUrl = 'logout';
  var res;

  print(constanst.fcm_token);
  final response = await http.post(Uri.parse(baseurl + loginUrl),
      headers: {"Accept": "application/json"}, body: {'deviceId': deviceid});

  print(constanst.android_device_id);
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Register with phone no
Future registerUserPhoneno(String phoneno, String countryCode, String userName,
    String stepCounter) async {
  String registeruserphonenoUrl = 'registerUserPhoneno_v2';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + registeruserphonenoUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'phoneno': phoneno,
    'countryCode': countryCode,
    'userName': userName,
    'step_counter': stepCounter
  });

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Register with phone no with otp verify
Future reg_mo_verifyotp(String otp, String userId, String phone,
    String apiToken, String step) async {
  String verifyotp = 'verifyotp';
  var res;

  final response = await http.post(Uri.parse(baseurl + verifyotp), headers: {
    "Accept": "application/json"
  }, body: {
    'Otp': otp,
    'userId': userId,
    'phoneno': phone,
    'userToken': apiToken,
    'step_counter': step
  });

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future reg_mo_updateverifyotp(String otp, String userId, String phone,
    String apiToken, String step) async {
  String verifyotp = 'verifyotp_phonenochange';
  var res;

  final response = await http.post(Uri.parse(baseurl + verifyotp), headers: {
    "Accept": "application/json"
  }, body: {
    'Otp': otp,
    'userId': userId,
    'phoneno': phone,
    'userToken': apiToken,
    'step_counter': step
  });

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

//Register with phone no with resend otp
Future reg_mo_resendotp(
    String userId, String apiToken, String phone, String countryCode) async {
  String verifyotp = 'resendotp_v2';
  var res;

  final response = await http.post(Uri.parse(baseurl + verifyotp), headers: {
    "Accept": "application/json"
  }, body: {
    'userId': userId,
    'phoneno': phone,
    'userToken': apiToken,
    'countryCode': countryCode
  });

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Register with email
Future registerUserEmail(String userName, String email, String stepCounter,
    String apiToken, String userId, String device) async {
  String registeruseremailUrl = 'registerUser';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + registeruseremailUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'username': userName,
    'email': email,
    'step_counter': stepCounter,
    'userToken': apiToken,
    'userId': userId,
    'device': device
  });

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

//Register with email  with resend otp
Future reg_email_resendotp(String userId, String apiToken, String email) async {
  String verifyotp = 'resendemailotp';
  var res;

  final response = await http.post(Uri.parse(baseurl + verifyotp),
      headers: {"Accept": "application/json"},
      body: {'userId': userId, 'userToken': apiToken, 'email': email});

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

//Register with email  with otp verify
Future reg_email_verifyotp(String otp, String userId, String apiToken,
    String email, String step) async {
  String verifyotp = 'verifyemailotp';
  var res;

  final response = await http.post(Uri.parse(baseurl + verifyotp), //2
      headers: {
        "Accept": "application/json"
      },
      body: {
        'Otp': otp,
        'userId': userId,
        'userToken': apiToken,
        'email': email,
        'step_counter': step
      });

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// final register
Future final_register(
    String email,
    String password,
    String countryCode,
    String phoneNumber,
    String device,
    String username,
    String stepCounter,
    String userid,
    String userToken) async {
  String verifyotp = 'register_v2';
  var res;

  final response = await http.post(Uri.parse(baseurl + verifyotp), //2
      headers: {
        "Accept": "application/json"
      },
      body: {
        'email': email,
        'password': password,
        'countryCode': countryCode,
        'phone_number': phoneNumber,
        'device': device,
        'username': username,
        'step_counter': stepCounter,
        'userId': userid,
        'userToken': userToken
      });

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  } else {}
  return res;
}

// forgot password using phone no && email
Future forgotpassword_ME(
    String phoneno, String countryCode, String email) async {
  String forgotMbl = 'forgotPasswordwithME';
  var res;

  final response = await http.post(Uri.parse(baseurl + forgotMbl),
      headers: {"Accept": "application/json"},
      body: {'phoneno': phoneno, 'countryCode': countryCode, 'email': email});

  print(phoneno);
  print(countryCode);
  print(email);

  print(response.request);
  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// forgot password otp verify
Future verifyforgototp(
    String otp, String phoneno, String countryCode, String email) async {
  String registeruserphonenoUrl = 'verifyforgototp';
  var res;

  final response = await http.post(Uri.parse(baseurl + registeruserphonenoUrl),
      headers: {
        "Accept": "application/json"
      },
      body: {
        'otp': otp,
        'phoneno': phoneno,
        'countryCode': countryCode,
        'email': email
      });

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// reset Paasword
Future resetPassword(
    String password, String countryCode, String phoneno, String email) async {
  String resetpasswordUrl = 'resetPassword';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + resetpasswordUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'password': password,
    'phoneno': phoneno,
    'countryCode': countryCode,
    'email': email
  });

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// get Category

Future getCategoryList() async {
  String getcategorylistUrl = 'getCategoryList';
  var res;

  final response = await http.get(Uri.parse(baseurl + getcategorylistUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// GetBussinessType
Future getBussinessType() async {
  String getbussinesstypeUrl = 'getBusinessType';
  var res;

  final response = await http.get(Uri.parse(baseurl + getbussinesstypeUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Add Bussiness Add
Future addbussiness(
    String userId,
    String userToken,
    String businessName,
    String businessType,
    String location,
    String longitude,
    String latitude,
    String otherMobile1,
    String country,
    String countryCode,
    String businessPhone,
    String stepCounter,
    String city,
    String email,
    String website,
    String aboutBusiness,
    File? file,
    String gstTaxVat,
    String state) async {
  String addbussinessprofileUrl = 'addUserBusinessProfile';
  var res;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + addbussinessprofileUrl),
  );
  var convertdatajson;
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  request.files.add(
    http.MultipartFile(
      'profilePicture',
      file!.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path,
    ),
  );
  request.headers.addAll(headers);
  request.fields.addAll({
    'userId': userId,
    'userToken': userToken,
    'business_name': businessName,
    'business_type': businessType,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'other_mobile1': otherMobile1,
    'country': country,
    'countryCode': countryCode,
    'business_phone': businessPhone,
    'step_counter': stepCounter,
    'city': city,
    'email': email,
    'website': website,
    'about_business': aboutBusiness,
    'gst_tax_vat': gstTaxVat,
    'state': state
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Get Category Type

Future getCateType() async {
  String getcatetypeUrl = 'getProducttypeList';
  var res;

  final response = await http.get(Uri.parse(baseurl + getcatetypeUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Get Category Grade

Future getCateGrade() async {
  String getcategradeUrl = 'getProductgradeList';
  var res;

  final response = await http.get(Uri.parse(baseurl + getcategradeUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Add Category
Future addcategory(String userId, String userToken, String locationInterest,
    String postType, String categoryId, String stepCounter) async {
  String registeruserphonenoUrl = 'addCategory';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + registeruserphonenoUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'user_id': userId,
    'userToken': userToken,
    'location_interest': locationInterest,
    'post_type': postType,
    'category_id': categoryId,
    'step_counter': stepCounter
  });

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Add Type
Future addtype(
    String userId, String userToken, String typeId, String stepCounter) async {
  String registeruserphonenoUrl = 'addProducttype';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + registeruserphonenoUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'user_id': userId,
    'userToken': userToken,
    'type_id': typeId,
    'step_counter': stepCounter
  });

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Add Grade
Future addgrade(
    String userId, String userToken, String gradeId, String stepCounter) async {
  String registeruserphonenoUrl = 'addProductgrade';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + registeruserphonenoUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'user_id': userId,
    'userToken': userToken,
    'grade_id': gradeId,
    'step_counter': stepCounter
  });

  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Get Bussiness Profile

Future getbussinessprofile(String userId, String userToken) async {
  String getmybusinessprofileUrl = 'getmybusinessprofile';
  var res;

  final response = await http.post(Uri.parse(baseurl + getmybusinessprofileUrl),
      headers: {"Accept": "application/json"},
      body: {'userId': userId, 'userToken': userToken});

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

// Get Colors

Future getColors() async {
  String getcolorlistUrl = 'getColorList';
  var res;

  final response = await http.get(Uri.parse(baseurl + getcolorlistUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Get Unit

Future getUnit() async {
  String getunitUrl = 'getUnitList';
  var res;

  final response = await http.get(Uri.parse(baseurl + getunitUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future addBuyPost(
    String userId,
    String userToken,
    String producttypeId,
    String productgradeId,
    String currency,
    String productPrice,
    String productQty,
    String colorId,
    String description,
    String unit,
    String unitPrice,
    String location,
    String latitude,
    String longitude,
    String imageCounter,
    String city,
    String state,
    String country,
    String stepCounter,
    String productName,
    String categoryId,) async {
  String addbussinessprofileUrl = 'addBuyPost_v2';
  var res;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + addbussinessprofileUrl),
  );
  var convertdatajson;
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  int j = 0;
  for (int i = 0; i < constanst.imagesList.length; i++) {
    j = j + 1;
    request.files.add(
      http.MultipartFile(
        'image$j',
        constanst.imagesList[i]!.readAsBytes().asStream(),
        constanst.imagesList[i]!.lengthSync(),
        filename: constanst.imagesList[i]!.path,
      ),
    );
  }
  /* var request =
  http.MultipartRequest('POST', Uri.parse(url + _scanQrCode));
  print(Uri.parse(url + _scanQrCode));
  request.files.add(http.MultipartFile.fromBytes(
      'picture',
      File(_image[i].path).readAsBytesSync(),
      filename: _image[i].path.split("/").last
  ));
  var res = await request.send();
  var responseData = await res.stream.toBytes();
  var result = String.fromCharCodes(responseData);
  print(_image[i].path);*/
  /*List<http.MultipartFile> newList = new List<http.MultipartFile>();

  for (int i = 0; i < imagesList.length; i++) {
    var path = await FlutterAbsolutePath.getAbsolutePath(imagesList[i].identifier);
    File imageFile =  File(path);

    var stream = new http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();

    var multipartFile = new http.MultipartFile("pictures", stream, length,
        filename: basename(imageFile.path));
    newList.add(multipartFile);
  }*/
  /*request.files.add(
    http.MultipartFile(
      'mainproductImage',
      file!.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path,
    ),
  )*/
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'producttype_id': producttypeId,
    'productgrade_id': productgradeId,
    'currency': currency,
    'product_price': productPrice,
    'unit': unit,
    'unit_of_price': unitPrice,
    'location': location,
    'product_qty': productQty,
    'color_id': colorId,
    'description': description,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'image_counter': imageCounter,
    'city': city,
    'state': state,
    'country': country,
    'step_counter': stepCounter,
    'product_name': productName,
    'category_id': categoryId
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future addSalePost(
    String userId,
    String userToken,
    String producttypeId,
    String productgradeId,
    String currency,
    String productPrice,
    String productQty,
    String colorId,
    String description,
    String unit,
    String unitPrice,
    String location,
    String latitude,
    String longitude,
    String imageCounter,
    String city,
    String state,
    String country,
    String stepCounter,
    String productName,
    String categoryId) async {
  String addbussinessprofileUrl = 'addSalePost_v2';
  var res;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + addbussinessprofileUrl),
  );
  var convertdatajson;
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  int j = 0;
  for (int i = 0; i < constanst.imagesList.length; i++) {
    j = j + 1;
    request.files.add(
      http.MultipartFile(
        'image$j',
        constanst.imagesList[i]!.readAsBytes().asStream(),
        constanst.imagesList[i]!.lengthSync(),
        filename: constanst.imagesList[i]!.path,
      ),
    );
  }
/*  request.files.add(
    http.MultipartFile(
      'mainproductImage',
      file!.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path,
    ),
  );*/
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'producttype_id': producttypeId,
    'productgrade_id': productgradeId,
    'currency': currency,
    'product_price': productPrice,
    'unit': unit,
    'unit_of_price': unitPrice,
    'location': location,
    'product_qty': productQty,
    'color_id': colorId,
    'description': description,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'image_counter': imageCounter,
    'city': city,
    'state': state,
    'country': country,
    'step_counter': stepCounter,
    'product_name': productName,
    'category_id': categoryId
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Get Category Type

Future getuser_Profile(String userId, String userToken) async {
  String registeruserphonenoUrl = 'getuserprofile';
  var res;

  final response = await http.post(Uri.parse(baseurl + registeruserphonenoUrl),
      headers: {"Accept": "application/json"},
      body: {'userId': userId, 'userToken': userToken});

  print(userId);
  print(userToken);
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Update Profile Picture
Future saveProfile(String userId, String userToken, File? file) async {
  String registeruserphonenoUrl = 'saveprofilepicture';

  var res;
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + registeruserphonenoUrl),
  );

  request.files.add(
    http.MultipartFile(
      'profilePicture',
      file!.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path,
    ),
  );
  request.headers.addAll(headers);
  request.fields.addAll({'userId': userId, 'userToken': userToken});

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

// Register with phone no
Future updateUserPhoneno(
    String phoneno, String countryCode, String userId, String userToken) async {
  String registeruserphonenoUrl = 'updatephonenumber';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + registeruserphonenoUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'userId': userId,
    'userToken': userToken,
    'countryCode': countryCode,
    'phoneno': phoneno
  });

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future updateUseremail(String email, String userId, String userToken) async {
  String registeruserphonenoUrl = 'updateemail';
  var res;

  final response = await http.post(Uri.parse(baseurl + registeruserphonenoUrl),
      headers: {"Accept": "application/json"},
      body: {'user_id': userId, 'userToken': userToken, 'email': email});

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future changePassword(
    String userId, String userToken, String newPassword) async {
  String resetpasswordUrl = 'changepassword';
  var res;

  final response = await http.post(Uri.parse(baseurl + resetpasswordUrl),
      headers: {
        "Accept": "application/json"
      },
      body: {
        'userId': userId,
        'userToken': userToken,
        'new_password': newPassword
      });

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future updatesocialmedia(
    String userId,
    String userToken,
    String instagramLink,
    String youtubeLink,
    String facebookLink,
    String linkedinLink,
    String twitterLink,
    String telegramLink) async {
  String resetpasswordUrl = 'updatesocialmedia';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + resetpasswordUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'userId': userId,
    'userToken': userToken,
    'instagram_link': instagramLink,
    'youtube_link': youtubeLink,
    'facebook_link': facebookLink,
    'linkedin_link': linkedinLink,
    'twitter_link': twitterLink,
    'telegram_link': telegramLink,
  });

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future updateUserBusinessProfile(
    String userId,
    String userToken,
    String businessName,
    String businessType,
    String location,
    String longitude,
    String latitude,
    String otherMobile1,
    String country,
    String countryCode,
    String businessPhone,
    String stepCounter,
    String city,
    String email,
    String website,
    String aboutBusiness,
    String businessId,
    String state,
    String username) async {
  String updateuserbusinessprofileUrl = 'updateUserBusinessProfile';
  var res;

  final response = await http
      .post(Uri.parse(baseurl + updateuserbusinessprofileUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'userId': userId,
    'userToken': userToken,
    'business_name': businessName,
    'business_type': businessType,
    'address': location,
    'latitude': latitude,
    'longitude': longitude,
    'other_mobile1': otherMobile1,
    'country': country,
    'countryCode': countryCode,
    'businessId': businessId,
    'business_phone': businessPhone,
    'step_counter': stepCounter,
    'city': city,
    'other_email': email,
    'website': website,
    'about_business': aboutBusiness,
    'state': state,
    'username': username
  });

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future getannual_capacity() async {
  String getannualcapacityUrl = 'getannualcapacity';
  var res;

  final response = await http.get(Uri.parse(baseurl + getannualcapacityUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future getannual_turnover() async {
  String getannualcapacityUrl = 'getannualturnovermaster';
  var res;

  final response = await http.get(Uri.parse(baseurl + getannualcapacityUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future getbusiness_document_types() async {
  String getannualcapacityUrl = 'getbusiness_document_types';
  var res;

  final response = await http.get(Uri.parse(baseurl + getannualcapacityUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future getSlider(String userId, String apiToken) async {
  String getsliderlistUrl =
      'getBannerImage?user_id=$userId&userToken=$apiToken';
  var res;

  final response = await http.get(Uri.parse(baseurl + getsliderlistUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getfilterdata() async {
  String getsliderlistUrl = 'getfilterdata';
  var res;

  final response = await http.get(Uri.parse(baseurl + getsliderlistUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getfilterdata_liveprice() async {
  String getsliderlistUrl = 'getfilterdata_liveprice';
  var res;

  final response = await http.get(Uri.parse(baseurl + getsliderlistUrl));

  print(response.statusCode);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

// Get Home Product
Future getHome_Post(
    String userId,
    String apiToken,
    String offset,
    String categoryId,
    String categoryFilterId,
    String producttypeFilterId,
    String productgradeFilterId,
    String posttypeFilter,
    String businesstypeId,
    String latitude,
    String longitude,
    String search) async {
  String gethomepostUrl =
      'getHomePost_v2?userId=$userId&userToken=$apiToken&offset=$offset&limit=20&category_id=$categoryId&category_filter_id=$categoryFilterId&producttype_filter_id=$producttypeFilterId&productgrade_filter_id=$productgradeFilterId&posttype_filter=$posttypeFilter&posttype_filter=$posttypeFilter&businesstype_id=$businesstypeId&latitude=$latitude&longitude=$longitude&search=$search';
  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

// Get Sale Post
Future getSale_Post(
    String userId,
    String apiToken,
    String limit,
    String offset,
    String categoryFilterId,
    String producttypeFilterId,
    String productgradeFilterId,
    String posttypeFilter,
    String businesstypeId,
    String latitude,
    String longitude,
    String search) async {
  String getsalepostUrl =
      'getSalePost_v2?userId=$userId&userToken=$apiToken&category_id=""&profileId=""&limit=$limit&offset=$offset&category_filter_id=$categoryFilterId&producttype_filter_id=$producttypeFilterId&productgrade_filter_id=$productgradeFilterId&posttype_filter=$posttypeFilter&posttype_filter=$posttypeFilter&businesstype_id=$businesstypeId&latitude=$latitude&longitude=$longitude&search=$search';
  var res;

  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));
  print(response.request);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

// Get Buyer Post
Future getBuyer_Post(
    String userId,
    String apiToken,
    String limit,
    String offset,
    String categoryFilterId,
    String producttypeFilterId,
    String productgradeFilterId,
    String posttypeFilter,
    String businesstypeId,
    String latitude,
    String longitude,
    String search) async {
  String getsalepostUrl =
      'getBuyPost_v2?userId=$userId&userToken=$apiToken&category_id=""&profileId=""&limit=$limit&offset=$offset&category_filter_id=$categoryFilterId&producttype_filter_id=$producttypeFilterId&productgrade_filter_id=$productgradeFilterId&posttype_filter=$posttypeFilter&posttype_filter=$posttypeFilter&businesstype_id=$businesstypeId&latitude=$latitude&longitude=$longitude&search=$search';
  var res;

  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.request);

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getHomeSearch_Post(String latitude, String longitude,
    String searchKeyword, String limit, String offset) async {
  String getsalepostUrl =
      'getHomePostSearch?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getPost_datail(
    String userId, String apiToken, String productId, String notiId) async {
  String getpostdatailUrl =
      'getBuyPostDetail_v2?userId=$userId&userToken=$apiToken&productId=$productId&notiId=$notiId';
  var res;

  final response = await http.get(Uri.parse(baseurl + getpostdatailUrl));

  print(response.request);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getPost_datail1(
    String userId, String apiToken, String productId, String notiId) async {
  String getpostdatailUrl =
      'getSalePostDetail_v2?userId=$userId&userToken=$apiToken&productId=$productId&notiId=$notiId';
  var res;

  final response = await http.get(Uri.parse(baseurl + getpostdatailUrl));

  print(response.request);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future similar_product_buyer(
    String productId, String limit, String offset) async {
  String getpostdatailUrl =
      'relatedpost_for_buy?productId=$productId&limit=$limit&offset=$offset';
  var res;

  final response = await http.get(Uri.parse(baseurl + getpostdatailUrl));

  print(response.request);

  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future similar_product_saler(
    String productId, String limit, String offset) async {
  String getpostdatailUrl =
      'relatedpost_for_sale?productId=$productId&limit=$limit&offset=$offset';
  var res;

  final response = await http.get(Uri.parse(baseurl + getpostdatailUrl));

  print(response.request);

  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getsaleSearch_Post(String latitude, String longitude,
    String searchKeyword, String limit, String offset) async {
  String getsalepostUrl = 'searchSalepost';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response =
      await http.post(Uri.parse(baseurl + getsalepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'latitude': latitude,
    'longitude': longitude,
    'searchKeyword': searchKeyword,
    'limit': limit,
    'offset': offset
  });

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getbuysearch_Post(String latitude, String longitude,
    String searchKeyword, String limit, String offset) async {
  String getsalepostUrl = 'searchBuypost';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response =
      await http.post(Uri.parse(baseurl + getsalepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'latitude': latitude,
    'longitude': longitude,
    'searchKeyword': searchKeyword,
    'limit': limit,
    'offset': offset
  });

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future gethomequicknew() async {
  String gethomequicknewUrl = 'getHomeQuickNewsList';
  var res;
  final response = await http.get(Uri.parse(baseurl + gethomequicknewUrl));

  print(response.request);

  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getnewss(String userId, String userToken) async {
  String getsalepostUrl = 'getNews?userId=$userId&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getQuicknews(String userId, String userToken, String offset) async {
  String getsalepostUrl =
      'newnews?userId=$userId&userToken=$userToken&offset=$offset&limit=20';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future news_like(String newsId, String userId, String userToken) async {
  String getsalepostUrl = 'addNewsLike';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.post(Uri.parse(baseurl + getsalepostUrl),
      headers: {"Accept": "application/json"},
      body: {'news_id': newsId, 'user_id': userId, 'userToken': userToken});

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future product_like(String newsId, String userId, String userToken) async {
  String getsalepostUrl = 'addProductLike';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.post(Uri.parse(baseurl + getsalepostUrl),
      headers: {"Accept": "application/json"},
      body: {'product_id': newsId, 'user_id': userId, 'userToken': userToken});

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future profile_like(String profileId, String userId, String userToken) async {
  String getsalepostUrl = 'addProfileLike';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.post(Uri.parse(baseurl + getsalepostUrl),
      headers: {
        "Accept": "application/json"
      },
      body: {
        'profile_id': profileId,
        'user_id': userId,
        'userToken': userToken
      });

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getnewssdetail(String userId, String userToken, String blogid) async {
  String getsalepostUrl =
      'getNewsDetails?userId=$userId&userToken=$userToken&newsId=$blogid';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getblogs(String userId, String userToken) async {
  String getsalepostUrl = 'getBlog?userId=$userId&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getblogsdetail(String userId, String userToken, String blogid) async {
  String getsalepostUrl =
      'getBlogDetails?userId=$userId&userToken=$userToken&blogId=$blogid';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future blog_like(String blogId, String userId, String userToken) async {
  String getsalepostUrl = 'addBlogLike';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.post(Uri.parse(baseurl + getsalepostUrl),
      headers: {"Accept": "application/json"},
      body: {'blog_id': blogId, 'user_id': userId, 'userToken': userToken});

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getFollowerLists(
    String userId, String userToken, String profileId, String search) async {
  String getfollowerlistUrl =
      'getFollowerList?userId=$userId&userToken=$userToken&profileId=$profileId&search=$search';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getfollowerlistUrl));

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getfollwingList(
    String userId, String userToken, String profileId, String search) async {
  String getsalepostUrl =
      'getFollowingList?userId=$userId&userToken=$userToken&profileId=$profileId&search=$search';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future followUnfollow(String isFollow, String otherUserId, String userid,
    String userToken) async {
  String getsalepostUrl = 'followUnfollow';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response =
      await http.post(Uri.parse(baseurl + getsalepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'isFollow': isFollow,
    'otherUserId': otherUserId,
    'userid': userid,
    'userToken': userToken
  });

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future addfav(String userid, String userToken, String productid) async {
  String getsalepostUrl = 'addFavoriteproduct';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.post(Uri.parse(baseurl + getsalepostUrl),
      headers: {"Accept": "application/json"},
      body: {'userid': userid, 'userToken': userToken, 'productid': productid});

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future removefav(String userid, String userToken, String productid) async {
  String getsalepostUrl = 'removeFavoriteproduct';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.post(Uri.parse(baseurl + getsalepostUrl),
      headers: {"Accept": "application/json"},
      body: {'userid': userid, 'userToken': userToken, 'removeid': productid});

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future favList(String userid, String userToken) async {
  String getsalepostUrl =
      'getFavoriteproduct?user_id=$userid&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getvideolist(String userId, String userToken) async {
  String getsalepostUrl = 'getvideolist?userId=$userId&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future gettutorialvideo_screen(String screenId) async {
  String getsalepostUrl = 'tutorialvideo_screen?screen_id=$screenId';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future gettutorialvideolist(
    String userId, String userToken, String offset) async {
  String getsalepostUrl =
      'gettutorialvideolist?user_id=$userId&userToken=$userToken&offset=$offset&limit=20';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getnotification(String userId, String userToken, String readStatus,
    String offset, String limit) async {
  String getsalepostUrl =
      'getNotificationlist?userId=$userId&userToken=$userToken&user_type=$readStatus&offset=$offset&limit=$limit';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getadminnotification(String userId, String userToken, String readStatus,
    String offset, String limit) async {
  String getsalepostUrl =
      'getadminNotificationlist?userId=$userId&userToken=$userToken&user_type=$readStatus&offset=$offset&limit=$limit';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getContactDetails(String userId, String userToken) async {
  String getsalepostUrl =
      'getContactDetails?userId=$userId&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future add_contact(
    String userid,
    String userToken,
    String feedback,
    String name,
    String email,
    String countryCode,
    String phonenumber,
    String message,
    String businessName,
    String contactBy) async {
  String getsalepostUrl = 'addContactUs';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response =
      await http.post(Uri.parse(baseurl + getsalepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'userId': userid,
    'userToken': userToken,
    'feedback': feedback,
    'name': name,
    'email': email,
    'countryCode': countryCode,
    'phonenumber': phonenumber,
    'message': message,
    'business_name': businessName,
    'contact_by': contactBy
  });

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future remove_noty(String userid, String userToken, String notifId) async {
  String getsalepostUrl = 'deleteNotification';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response =
      await http.post(Uri.parse(baseurl + getsalepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'notificationId': notifId,
    'userId': userid,
    'userToken': userToken,
  });

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future adminremove_noty(String userid, String userToken, String notifId) async {
  String getsalepostUrl =
      'deleteadminnotification?notification_id=$notifId&user_id=$userid&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future count_notify(String userid, String userToken) async {
  String getsalepostUrl =
      'getNotificationCount?userId=$userid&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getStaticPage() async {
  String getsalepostUrl = 'getStaticPage?staticId=6';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getread_all(String userid, String userToken) async {
  String getsalepostUrl =
      'readallnotification?userId=$userid&userToken=$userToken';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getupcoming_exbition(String userId, String userToken, String offset,
    String limit, String categoryFilterId) async {
  String getsalepostUrl =
      'getupcommingexhibition?userId=$userId&userToken=$userToken&offset=$offset&limit=$limit&category_filter_id=$categoryFilterId';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getpast_exbition(String userId, String userToken, String offset,
    String limit, String categoryFilterId) async {
  String getsalepostUrl =
      'getpastexhibition?userId=$userId&userToken=$userToken&offset=$offset&limit=$limit&category_filter_id=$categoryFilterId';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future exbitionlike_like(String exId, String userId, String userToken) async {
  //String getSalePost_url = 'addNewsLike';
  String getsalepostUrl =
      'addexhibitionlike?user_id=$userId&userToken=$userToken&ex_id=$exId';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getexbitiondetail(String userId, String userToken, String exId) async {
  String getsalepostUrl =
      'exhibitiondetail?userId=$userId&userToken=$userToken&ex_id=$exId';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getlive_price(
    String offset,
    String limit,
    String search,
    String category,
    String company,
    String country,
    String state,
    String date) async {
  String getsalepostUrl =
      'getPriceList?offset=$offset&limit=$limit&search=$search&category=$category&company=$company&country=$country&state=$state&date=$date';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future get_coderecord(String code_id, String offset) async {
  String getsalepostUrl =
      'getcoderecord?code_id=$code_id&offset=$offset&limit=20';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

// Get Sale Product List
Future getsale_PostList(String userId, String apiToken, String limit,
    String offset, String profileid) async {
  String gethomepostUrl =
      'getSalePost_v2?userId=$userId&userToken=$apiToken&category_id=0&limit=$limit&offset=$offset&profileId=$profileid';
  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future save_prostatus(String productId, String productStatus) async {
  String gethomepostUrl =
      'saveproductstatus?post_id=$productId&product_status=$productStatus';
  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future push_notification(String productId) async {
  String gethomepostUrl = 'pushnotification';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + gethomepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'product_id': productId,
  });

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future deletesalepost(String productId, String userId, String userToken) async {
  String gethomepostUrl = 'deleteSalePost';
  var res;

  final response = await http.post(Uri.parse(baseurl + gethomepostUrl),
      headers: {
        "Accept": "application/json"
      },
      body: {
        'productId': productId,
        'user_id': userId,
        'userToken': userToken
      });

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future deletebuypost(String productId, String userId, String userToken) async {
  String gethomepostUrl = 'deleteBuyPost';
  var res;

  final response = await http.post(Uri.parse(baseurl + gethomepostUrl),
      headers: {
        "Accept": "application/json"
      },
      body: {
        'productId': productId,
        'user_id': userId,
        'userToken': userToken
      });

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getbuy_PostList(String userId, String apiToken, String limit,
    String offset, String profileid) async {
  String gethomepostUrl =
      'getBuyPost_v2?userId=$userId&userToken=$apiToken&category_id=0&limit=$limit&offset=$offset&profileId=$profileid';
  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future deletePostSubImage(
    String subImageId, String userId, String userToken) async {
  String gethomepostUrl = 'deletePostSubImage';
  var res;

  final response = await http.post(Uri.parse(baseurl + gethomepostUrl),
      headers: {
        "Accept": "application/json"
      },
      body: {
        'subImageId': subImageId,
        'user_id': userId,
        'userToken': userToken
      });

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future addPostSubImage(String userId, String userToken, String productId,
    String imageCounter) async {
  String gethomepostUrl = 'addSalePostImage';
  var res;
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + gethomepostUrl),
  );
  /* final response = await http.post(Uri.parse(baseurl + getHomePost_url),
      headers: {"Accept": "application/json"},
      body: {'user_id': user_id,'userToken':userToken,'productId':productId,'image_counter':image_counter});*/
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  int j = 0;
  for (int i = 0; i < constanst.imagesList.length; i++) {
    j = j + 1;
    request.files.add(
      http.MultipartFile(
        'image$j',
        constanst.imagesList[i]!.readAsBytes().asStream(),
        constanst.imagesList[i]!.lengthSync(),
        filename: constanst.imagesList[i]!.path,
      ),
    );
  }
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'productId': productId,
    'image_counter': imageCounter
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future addBuyeSubImage(String userId, String userToken, String productId,
    String imageCounter) async {
  String gethomepostUrl = 'addBuyPostImage';
  var res;
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + gethomepostUrl),
  );
  /* final response = await http.post(Uri.parse(baseurl + getHomePost_url),
      headers: {"Accept": "application/json"},
      body: {'user_id': user_id,'userToken':userToken,'productId':productId,'image_counter':image_counter});*/
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  int j = 0;
  for (int i = 0; i < constanst.imagesList.length; i++) {
    j = j + 1;
    request.files.add(
      http.MultipartFile(
        'image$j',
        constanst.imagesList[i]!.readAsBytes().asStream(),
        constanst.imagesList[i]!.lengthSync(),
        filename: constanst.imagesList[i]!.path,
      ),
    );
  }
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'productId': productId,
    'image_counter': imageCounter
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

// update Post
Future updateSalePost(
    String userId,
    String userToken,
    String producttypeId,
    String productgradeId,
    String currency,
    String productPrice,
    String productQty,
    String colorId,
    String description,
    String unit,
    String unitPrice,
    String location,
    String latitude,
    String longitude,
    String imageCounter,
    String city,
    String state,
    String country,
    String stepCounter,
    String productName,
    String categoryId,
    File? file,
    String productid) async {
  String addbussinessprofileUrl = 'updateSalePost_v2';
  var res;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + addbussinessprofileUrl),
  );
  var convertdatajson;
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  int j = 0;

/*  for(int i=0;i<constanst.imagesList.length;i++){
    j=j+1;
    request.files.add(
      http.MultipartFile(
        'image$j',
        constanst.imagesList[i]!.readAsBytes().asStream(),
        constanst.imagesList[i]!.lengthSync(),
        filename: constanst.imagesList[i]!.path,
      ),
    );
  }*/
  if (file != null) {
    request.files.add(
      http.MultipartFile(
        'mainproductImage',
        file!.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path,
      ),
    );
  }
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'producttype_id': producttypeId,
    'productgrade_id': productgradeId,
    'currency': currency,
    'product_price': productPrice,
    'unit': unit,
    'unit_of_price': unitPrice,
    'location': location,
    'product_qty': productQty,
    'color_id': colorId,
    'description': description,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'image_counter': imageCounter,
    'city': city,
    'state': state,
    'country': country,
    'step_counter': stepCounter,
    'product_name': productName,
    'category_id': categoryId,
    'productId': productid
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future updateBuyerPost(
    String userId,
    String userToken,
    String producttypeId,
    String productgradeId,
    String currency,
    String productPrice,
    String productQty,
    String colorId,
    String description,
    String unit,
    String unitPrice,
    String location,
    String latitude,
    String longitude,
    String imageCounter,
    String city,
    String state,
    String country,
    String stepCounter,
    String productName,
    String categoryId,
    File? file,
    String productid) async {
  String addbussinessprofileUrl = 'updateBuyPost_v2';
  var res;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + addbussinessprofileUrl),
  );
  var convertdatajson;
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  int j = 0;

/*  for(int i=0;i<constanst.imagesList.length;i++){
    j=j+1;
    request.files.add(
      http.MultipartFile(
        'image$j',
        constanst.imagesList[i]!.readAsBytes().asStream(),
        constanst.imagesList[i]!.lengthSync(),
        filename: constanst.imagesList[i]!.path,
      ),
    );
  }*/
  if (file != null) {
    request.files.add(
      http.MultipartFile(
        'mainproductImage',
        file!.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path,
      ),
    );
  }
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'producttype_id': producttypeId,
    'productgrade_id': productgradeId,
    'currency': currency,
    'product_price': productPrice,
    'unit': unit,
    'unit_of_price': unitPrice,
    'location': location,
    'product_qty': productQty,
    'color_id': colorId,
    'description': description,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'image_counter': imageCounter,
    'city': city,
    'state': state,
    'country': country,
    'step_counter': stepCounter,
    'product_name': productName,
    'category_id': categoryId,
    'productId': productid
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future addProducttype(
    String userId, String userToken, String typeId, String stepCounter) async {
  String gethomepostUrl = 'addProducttype';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + gethomepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'user_id': userId,
    'userToken': userToken,
    'type_id': typeId,
    'step_counter': stepCounter
  });

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future addProductgrade(
    String userId, String userToken, String gradeId, String stepCounter) async {
  String gethomepostUrl = 'addProductgrade';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + gethomepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'user_id': userId,
    'userToken': userToken,
    'grade_id': gradeId,
    'step_counter': stepCounter
  });

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future get_directory(
    String userId,
    String apiToken,
    String offset,
    String categoryFilterId,
    String producttypeFilterId,
    String productgradeFilterId,
    String posttypeFilter,
    String businesstypeId,
    String latitude,
    String longitude,
    String search) async {
  String gethomepostUrl =
      'getdirectory?userId=$userId&offset=$offset&limit=20&category_filter_id=$categoryFilterId&producttype_filter_id=$producttypeFilterId&productgrade_filter_id=$productgradeFilterId&posttype_filter=$posttypeFilter&posttype_filter=$posttypeFilter&businesstype_id=$businesstypeId&latitude=$latitude&longitude=$longitude&search=$search';

  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future get_exhibitor(
    String offset,
    String categoryId,
    String gradeId,
    String typeId,
    String businesstypeId,
    String postType,
    String latitude,
    String longitude,
    String search) async {
  String gethomepostUrl =
      'getexhibitor?offset=$offset&limit=20&category_id=$categoryId&grade_id=$gradeId&type_id=$typeId&businesstype_id=$businesstypeId&post_type=$postType&latitude=$latitude&longitude=$longitude&search=$search';
  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future updateBusinessVerification(
    String userId,
    String userToken,
    String registrationDate,
    String panNumber,
    String exportImportNumber,
    String premises,
    String gstTaxVat,
    String currency_20_21,
    String amount_20_21,
    String currency_21_22,
    String amount_21_22,
    String currency_22_23,
    String amount_22_23,
    String docType,
    String productionCapacity,
    File? file) async {
  var res;
  try {
    String addbussinessprofileUrl = 'updateBusinessVerification';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseurl + addbussinessprofileUrl),
    );
    var convertdatajson;
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    if (file != null) {
      request.files.add(
        http.MultipartFile(
          'document',
          file!.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path,
        ),
      );
    }
    request.headers.addAll(headers);
    request.fields.addAll({
      'userId': userId,
      'userToken': userToken,
      'registration_date': registrationDate,
      'pan_number': panNumber,
      'export_import_number': exportImportNumber,
      'premises': premises,
      'gst_tax_vat': gstTaxVat,
      'currency_20_21': currency_20_21,
      'amount_20_21': amount_20_21,
      'currency_21_22': currency_21_22,
      'amount_21_22': amount_21_22,
      'currency_22_23': currency_22_23,
      'amount_22_23': amount_22_23,
      'doc_type': docType,
      'production_capacity': productionCapacity,
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);

    if (response.statusCode == 200) {
      //Map<String, dynamic> responseJson = json.decode(response.body);
      res = jsonDecode(response.body);
      print("res $res");
    }
  } catch (e) {
    print('Error: $e');
    throw e;
  }

  return res;
}

Future get_productname() async {
  String gethomepostUrl = 'getProductName';

  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future get_deletedocument(String docu_id) async {
  String gethomepostUrl = 'deletedocument?document_id=$docu_id';

  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future remove_docu(String docu_id) async {
  String getsalepostUrl = 'deletedocument?document_id=$docu_id';
  // String getSalePost_url = 'searchSalepost?latitude=$latitude&longitude=$longitude&searchKeyword=$searchKeyword&limit=$limit&offset=$offset';
  var res;

  // final response = await http.get(Uri.parse(baseurl + getSalePost_url));
  final response = await http.get(Uri.parse(baseurl + getsalepostUrl));

  print(response.statusCode);
  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);

    print(res['data']);
  }
  return res;
}

Future get_profileliked_user(String profile_id) async {
  String gethomepostUrl = 'getprofileliked_user?profile_id=$profile_id';

  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future get_profileviewd_user(String profile_id) async {
  String gethomepostUrl = 'getprofileviewed_user?profile_id=$profile_id';

  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future share_count(String profile_id, user_id) async {
  String gethomepostUrl =
      'countprofileshare?profile_id=$profile_id&user_id=$user_id';

  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future get_profiles_share(String profile_id) async {
  String gethomepostUrl = 'getprofileshare?profile_id=$profile_id';

  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl));

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future getbusinessprofileDetail(
    String userId, String apiToken, String profile_id) async {
  String getpostdatailUrl = 'getbusinessprofileDetail';
  var res;

  final response = await http.post(Uri.parse(baseurl + getpostdatailUrl),
      body: {
        'userId': userId,
        'userToken': apiToken,
        'profile_id': profile_id
      });

  print(response.request);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future addReview(String userId, String userToken, String profile_id,
    String rating, String comment, File? file) async {
  String addbussinessprofileUrl = 'addProfileComment_with_rating';
  var res;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + addbussinessprofileUrl),
  );

  Map<String, String> headers = {"Content-type": "multipart/form-data"};

  if (file != null) {
    request.files.add(
      http.MultipartFile(
        'com_image',
        file!.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path,
      ),
    );
  }
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'profile_id': profile_id,
    'rating': rating,
    'comment': comment
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future Getcomment(String profileid, String offset, String limit) async {
  String getpostdatailUrl = 'getprofilereview';
  var res;

  final response = await http.post(Uri.parse(baseurl + getpostdatailUrl),
      body: {'profile_id': profileid, 'offset': offset, 'limit': limit});

  print(response.request);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future addReply(String userId, String userToken, String comment_id,
    String profile_id, String comment) async {
  String gethomepostUrl = 'addprofilesubcomment';
  var res;

  final response =
      await http.post(Uri.parse(baseurl + gethomepostUrl), headers: {
    "Accept": "application/json"
  }, body: {
    'user_id': userId,
    'userToken': userToken,
    'comment_id': comment_id,
    'profile_id': profile_id,
    'comment': comment
  });

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future editReview(String userId, String userToken, String comment_id,
    String rating, String comment, File? file) async {
  String addbussinessprofileUrl = 'editprofilereviewwithrating';
  var res;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl + addbussinessprofileUrl),
  );

  Map<String, String> headers = {"Content-type": "multipart/form-data"};

  if (file != null) {
    request.files.add(
      http.MultipartFile(
        'com_image',
        file!.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path,
      ),
    );
  }
  request.headers.addAll(headers);
  request.fields.addAll({
    'user_id': userId,
    'userToken': userToken,
    'comment_id': comment_id,
    'rating': rating,
    'comment': comment
  });

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
    print("res $res");
  }
  return res;
}

Future deletemyreview(String comment_id) async {
  String gethomepostUrl = 'deletemyreview';
  var res;

  final response = await http.post(Uri.parse(baseurl + gethomepostUrl),
      headers: {"Accept": "application/json"},
      body: {'comment_id': comment_id});

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}

Future get_databytimeduration(String code_id) async {
  String gethomepostUrl = 'getdatabytimeduration?code_id=$code_id';
  var res;

  final response = await http.get(Uri.parse(baseurl + gethomepostUrl),
      headers: {"Accept": "application/json"});

  print(response.request);
  print(response.body);

  if (response.statusCode == 200) {
    //Map<String, dynamic> responseJson = json.decode(response.body);
    res = jsonDecode(response.body);
  }
  return res;
}
