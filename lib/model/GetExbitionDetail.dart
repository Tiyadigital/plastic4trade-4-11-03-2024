class GetExbitionDetail {
  int? status;
  String? message;
  Data? data;

  GetExbitionDetail({this.status, this.message, this.data});

  GetExbitionDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  Null? shortDescription;
  String? title;
  String? longDescription;
  String? metaDescription;
  String? image;
  String? likeCounter;
  int? viewCounter;
  String? startDate;
  String? endDate;
  String? slug;
  String? status;
  String? location;
  String? latitude;
  String? longitude;
  String? notificationStatus;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? isLike;
  String? imageUrl;

  Data(
      {this.id,
        this.shortDescription,
        this.title,
        this.longDescription,
        this.metaDescription,
        this.image,
        this.likeCounter,
        this.viewCounter,
        this.startDate,
        this.endDate,
        this.slug,
        this.status,
        this.location,
        this.latitude,
        this.longitude,
        this.notificationStatus,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isLike,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortDescription = json['short_description'];
    title = json['title'];
    longDescription = json['long_description'];
    metaDescription = json['meta_description'];
    image = json['image'];
    likeCounter = json['like_counter'];
    viewCounter = json['view_counter'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    slug = json['slug'];
    status = json['status'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    notificationStatus = json['notification_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isLike = json['isLike'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short_description'] = this.shortDescription;
    data['title'] = this.title;
    data['long_description'] = this.longDescription;
    data['meta_description'] = this.metaDescription;
    data['image'] = this.image;
    data['like_counter'] = this.likeCounter;
    data['view_counter'] = this.viewCounter;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['notification_status'] = this.notificationStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['isLike'] = this.isLike;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
