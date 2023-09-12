class getTutorialVideo {
  int? _status;
  String? _message;
  List<Result>? _result;

  getTutorialVideo({int? status, String? message, List<Result>? result}) {
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (result != null) {
      this._result = result;
    }
  }

  int? get status => _status;
  set status(int? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Result>? get result => _result;
  set result(List<Result>? result) => _result = result;

  getTutorialVideo.fromJson(Map<String, dynamic> json) {
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
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._result != null) {
      data['result'] = this._result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? _id;
  String? _screenName;
  String? _title;
  String? _videoLink;
  String? _metaDescription;
  String? _longDescription;
  String? _notificationStatus;
  String? _slug;
  String? _createdAt;
  String? _updatedAt;
  Null? _deletedAt;
  String? _videoId;
  Screen? _screen;

  Result(
      {int? id,
        String? screenName,
        String? title,
        String? videoLink,
        String? metaDescription,
        String? longDescription,
        String? notificationStatus,
        String? slug,
        String? createdAt,
        String? updatedAt,
        Null? deletedAt,
        String? videoId,
        Screen? screen}) {
    if (id != null) {
      this._id = id;
    }
    if (screenName != null) {
      this._screenName = screenName;
    }
    if (title != null) {
      this._title = title;
    }
    if (videoLink != null) {
      this._videoLink = videoLink;
    }
    if (metaDescription != null) {
      this._metaDescription = metaDescription;
    }
    if (longDescription != null) {
      this._longDescription = longDescription;
    }
    if (notificationStatus != null) {
      this._notificationStatus = notificationStatus;
    }
    if (slug != null) {
      this._slug = slug;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (deletedAt != null) {
      this._deletedAt = deletedAt;
    }
    if (videoId != null) {
      this._videoId = videoId;
    }
    if (screen != null) {
      this._screen = screen;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get screenName => _screenName;
  set screenName(String? screenName) => _screenName = screenName;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get videoLink => _videoLink;
  set videoLink(String? videoLink) => _videoLink = videoLink;
  String? get metaDescription => _metaDescription;
  set metaDescription(String? metaDescription) =>
      _metaDescription = metaDescription;
  String? get longDescription => _longDescription;
  set longDescription(String? longDescription) =>
      _longDescription = longDescription;
  String? get notificationStatus => _notificationStatus;
  set notificationStatus(String? notificationStatus) =>
      _notificationStatus = notificationStatus;
  String? get slug => _slug;
  set slug(String? slug) => _slug = slug;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  Null? get deletedAt => _deletedAt;
  set deletedAt(Null? deletedAt) => _deletedAt = deletedAt;
  String? get videoId => _videoId;
  set videoId(String? videoId) => _videoId = videoId;
  Screen? get screen => _screen;
  set screen(Screen? screen) => _screen = screen;

  Result.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _screenName = json['screen_name'];
    _title = json['title'];
    _videoLink = json['video_link'];
    _metaDescription = json['meta_description'];
    _longDescription = json['long_description'];
    _notificationStatus = json['notification_status'];
    _slug = json['slug'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _videoId = json['video_id'];
    _screen =
    json['screen'] != null ? new Screen.fromJson(json['screen']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['screen_name'] = this._screenName;
    data['title'] = this._title;
    data['video_link'] = this._videoLink;
    data['meta_description'] = this._metaDescription;
    data['long_description'] = this._longDescription;
    data['notification_status'] = this._notificationStatus;
    data['slug'] = this._slug;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['deleted_at'] = this._deletedAt;
    data['video_id'] = this._videoId;
    if (this._screen != null) {
      data['screen'] = this._screen!.toJson();
    }
    return data;
  }
}

class Screen {
  int? _id;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
  Null? _deletedAt;

  Screen(
      {int? id,
        String? name,
        String? createdAt,
        String? updatedAt,
        Null? deletedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (deletedAt != null) {
      this._deletedAt = deletedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  Null? get deletedAt => _deletedAt;
  set deletedAt(Null? deletedAt) => _deletedAt = deletedAt;

  Screen.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['deleted_at'] = this._deletedAt;
    return data;
  }
}
