class GetProductView {
  int? status;
  List<Data>? data;

  GetProductView({this.status, this.data});

  GetProductView.fromJson(Map<String, dynamic> json) {
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
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? postId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? username;
  String? userImage;
  String? imageUrl;

  Data(
      {this.id,
        this.postId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.username,
        this.userImage,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    username = json['username'];
    userImage = json['userImage'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['post_id'] = postId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['username'] = username;
    data['userImage'] = userImage;
    data['image_url'] = imageUrl;
    return data;
  }
}
