class Get_shareUser {
  int? status;
  List<Data>? data;

  Get_shareUser({this.status, this.data});

  Get_shareUser.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['profile_id'] = this.profileId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['username'] = this.username;
    data['userImage'] = this.userImage;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
