class Get_likeUser {
  int? _status;
  List<Data>? _data;

  Get_likeUser({int? status, List<Data>? data}) {
    if (status != null) {
      _status = status;
    }
    if (data != null) {
      _data = data;
    }
  }

  int? get status => _status;
  set status(int? status) => _status = status;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;

  Get_likeUser.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? _id;
  String? _userId;
  String? _profileId;
  String? _isLike;
  String? _createdAt;
  String? _updatedAt;
  String? _username;
  String? _userImage;
  String? _imageUrl;

  Data(
      {int? id,
        String? userId,
        String? profileId,
        String? isLike,
        String? createdAt,
        String? updatedAt,
        String? username,
        String? userImage,
        String? imageUrl}) {
    if (id != null) {
      _id = id;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (profileId != null) {
      _profileId = profileId;
    }
    if (isLike != null) {
      _isLike = isLike;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (username != null) {
      _username = username;
    }
    if (userImage != null) {
      _userImage = userImage;
    }
    if (imageUrl != null) {
      _imageUrl = imageUrl;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get profileId => _profileId;
  set profileId(String? profileId) => _profileId = profileId;
  String? get isLike => _isLike;
  set isLike(String? isLike) => _isLike = isLike;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get username => _username;
  set username(String? username) => _username = username;
  String? get userImage => _userImage;
  set userImage(String? userImage) => _userImage = userImage;
  String? get imageUrl => _imageUrl;
  set imageUrl(String? imageUrl) => _imageUrl = imageUrl;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _profileId = json['profile_id'];
    _isLike = json['isLike'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _username = json['username'];
    _userImage = json['userImage'];
    _imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['profile_id'] = _profileId;
    data['isLike'] = _isLike;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['username'] = _username;
    data['userImage'] = _userImage;
    data['image_url'] = _imageUrl;
    return data;
  }
}
