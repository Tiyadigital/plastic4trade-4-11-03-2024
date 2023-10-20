class ProductShare {
  int? status;
  List<Data>? data;

  ProductShare({this.status, this.data});

  ProductShare.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? userId;
  String? profileId;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? userImage;
  String? imageUrl;

  Data(
      {this.id,
        this.userId,
        this.profileId,
        this.createdAt,
        this.updatedAt,
        this.username,
        this.userImage,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    profileId = json['profile_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    username = json['username'];
    userImage = json['userImage'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['profile_id'] = profileId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['username'] = username;
    data['userImage'] = userImage;
    data['image_url'] = imageUrl;
    return data;
  }
}
