class QuickNews {
  int? _status;
  String? _message;
  List<Result>? _result;

  QuickNews({int? status, String? message, List<Result>? result}) {
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

  QuickNews.fromJson(Map<String, dynamic> json) {
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
  String? _newsTitle;
  Null? _shortDescription;
  String? _longDescription;
  Null? _metaDescription;
  String? _newsDate;
  String? _newsTime;
  String? _newsImage;
  Null? _likeCounter;
  String? _slug;
  String? _status;
  String? _notificationStatus;
  String? _isQuickNews;
  int? _viewCounter;
  String? _createdAt;
  String? _updatedAt;
  Null? _imageUrl;

  Result(
      {int? id,
        String? newsTitle,
        Null? shortDescription,
        String? longDescription,
        Null? metaDescription,
        String? newsDate,
        String? newsTime,
        String? newsImage,
        Null? likeCounter,
        String? slug,
        String? status,
        String? notificationStatus,
        String? isQuickNews,
        int? viewCounter,
        String? createdAt,
        String? updatedAt,
        Null? imageUrl}) {
    if (id != null) {
      this._id = id;
    }
    if (newsTitle != null) {
      this._newsTitle = newsTitle;
    }
    if (shortDescription != null) {
      this._shortDescription = shortDescription;
    }
    if (longDescription != null) {
      this._longDescription = longDescription;
    }
    if (metaDescription != null) {
      this._metaDescription = metaDescription;
    }
    if (newsDate != null) {
      this._newsDate = newsDate;
    }
    if (newsTime != null) {
      this._newsTime = newsTime;
    }
    if (newsImage != null) {
      this._newsImage = newsImage;
    }
    if (likeCounter != null) {
      this._likeCounter = likeCounter;
    }
    if (slug != null) {
      this._slug = slug;
    }
    if (status != null) {
      this._status = status;
    }
    if (notificationStatus != null) {
      this._notificationStatus = notificationStatus;
    }
    if (isQuickNews != null) {
      this._isQuickNews = isQuickNews;
    }
    if (viewCounter != null) {
      this._viewCounter = viewCounter;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (imageUrl != null) {
      this._imageUrl = imageUrl;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get newsTitle => _newsTitle;
  set newsTitle(String? newsTitle) => _newsTitle = newsTitle;
  Null? get shortDescription => _shortDescription;
  set shortDescription(Null? shortDescription) =>
      _shortDescription = shortDescription;
  String? get longDescription => _longDescription;
  set longDescription(String? longDescription) =>
      _longDescription = longDescription;
  Null? get metaDescription => _metaDescription;
  set metaDescription(Null? metaDescription) =>
      _metaDescription = metaDescription;
  String? get newsDate => _newsDate;
  set newsDate(String? newsDate) => _newsDate = newsDate;
  String? get newsTime => _newsTime;
  set newsTime(String? newsTime) => _newsTime = newsTime;
  String? get newsImage => _newsImage;
  set newsImage(String? newsImage) => _newsImage = newsImage;
  Null? get likeCounter => _likeCounter;
  set likeCounter(Null? likeCounter) => _likeCounter = likeCounter;
  String? get slug => _slug;
  set slug(String? slug) => _slug = slug;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get notificationStatus => _notificationStatus;
  set notificationStatus(String? notificationStatus) =>
      _notificationStatus = notificationStatus;
  String? get isQuickNews => _isQuickNews;
  set isQuickNews(String? isQuickNews) => _isQuickNews = isQuickNews;
  int? get viewCounter => _viewCounter;
  set viewCounter(int? viewCounter) => _viewCounter = viewCounter;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  Null? get imageUrl => _imageUrl;
  set imageUrl(Null? imageUrl) => _imageUrl = imageUrl;

  Result.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _newsTitle = json['news_title'];
    _shortDescription = json['short_description'];
    _longDescription = json['long_description'];
    _metaDescription = json['meta_description'];
    _newsDate = json['news_date'];
    _newsTime = json['news_time'];
    _newsImage = json['newsImage'];
    _likeCounter = json['like_counter'];
    _slug = json['slug'];
    _status = json['status'];
    _notificationStatus = json['notification_status'];
    _isQuickNews = json['is_quick_news'];
    _viewCounter = json['view_counter'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['news_title'] = this._newsTitle;
    data['short_description'] = this._shortDescription;
    data['long_description'] = this._longDescription;
    data['meta_description'] = this._metaDescription;
    data['news_date'] = this._newsDate;
    data['news_time'] = this._newsTime;
    data['newsImage'] = this._newsImage;
    data['like_counter'] = this._likeCounter;
    data['slug'] = this._slug;
    data['status'] = this._status;
    data['notification_status'] = this._notificationStatus;
    data['is_quick_news'] = this._isQuickNews;
    data['view_counter'] = this._viewCounter;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['image_url'] = this._imageUrl;
    return data;
  }
}
