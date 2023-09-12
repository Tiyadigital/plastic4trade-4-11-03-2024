class Get_likeUser {
  int? _status;
  List<Data>? _data;

  Get_likeUser({int? status, List<Data>? data}) {
    if (status != null) {
      this._status = status;
    }
    if (data != null) {
      this._data = data;
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
        _data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
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
      this._id = id;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (profileId != null) {
      this._profileId = profileId;
    }
    if (isLike != null) {
      this._isLike = isLike;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (username != null) {
      this._username = username;
    }
    if (userImage != null) {
      this._userImage = userImage;
    }
    if (imageUrl != null) {
      this._imageUrl = imageUrl;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['profile_id'] = this._profileId;
    data['isLike'] = this._isLike;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['username'] = this._username;
    data['userImage'] = this._userImage;
    data['image_url'] = this._imageUrl;
    return data;
  }
}
