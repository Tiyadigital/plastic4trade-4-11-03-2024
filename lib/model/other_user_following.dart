// ignore_for_file: camel_case_types

class getOtherFollowingList {
  int? status;
  String? message;
  int? totalFollowers;
  List<Result>? result;

  getOtherFollowingList(
      {this.status, this.message, this.totalFollowers, this.result});

  getOtherFollowingList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalFollowers = json['totalFollowers'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalFollowers'] = this.totalFollowers;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  String? image;
  String? name;
  String? businessType;
  String? status;
  int? isFollowing;

  Result(
      {this.id,
        this.image,
        this.name,
        this.businessType,
        this.status,
        this.isFollowing});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    businessType = json['businessType'];
    status = json['Status'];
    isFollowing = json['is_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['businessType'] = businessType;
    data['Status'] = status;
    data['is_following'] = isFollowing;
    return data;
  }
}
