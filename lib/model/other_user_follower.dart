class getOtherFollowerList {
  int? status;
  String? message;
  int? totalFollowers;
  List<Result>? result;

  getOtherFollowerList(
      {this.status, this.message, this.totalFollowers, this.result});

  getOtherFollowerList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalFollowers = json['totalFollowers'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['totalFollowers'] = totalFollowers;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
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
