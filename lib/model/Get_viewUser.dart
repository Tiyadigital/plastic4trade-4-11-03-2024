class Get_viewUser {
  int? status;
  List<Data>? data;

  Get_viewUser({this.status, this.data});

  Get_viewUser.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? profileId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? username;
  String? userImage;
  String? imageUrl;

  Data(
      {this.id,
        this.profileId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.username,
        this.userImage,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profile_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    username = json['username'];
    userImage = json['userImage'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_id'] = this.profileId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['username'] = this.username;
    data['userImage'] = this.userImage;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
