class getTutorialVideo_dialog {
  int? _status;
  String? _message;
  Result? _result;

  getTutorialVideo_dialog({int? status, String? message, Result? result}) {
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
  Result? get result => _result;
  set result(Result? result) => _result = result;

  getTutorialVideo_dialog.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._result != null) {
      data['result'] = this._result!.toJson();
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
        Null? deletedAt}) {
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
    return data;
  }
}
