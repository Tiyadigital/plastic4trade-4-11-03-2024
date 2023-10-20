class ApiResponse {
  int? status;
  String? message;
  List<Result>? result;

  ApiResponse({this.status, this.message, this.result});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }
}

class Result {
  int? interestId;
  String? productId;
  String? userId;
  String? username;
  String? imageUrl;
  String? createdAt;

  Result({this.interestId, this.productId, this.userId, this.username, this.imageUrl, this.createdAt});

  Result.fromJson(Map<String, dynamic> json) {
    interestId = json['interestId'];
    productId = json['productId'];
    userId = json['userId'];
    username = json['username'];
    imageUrl = json['profile_image'];
    createdAt = json['created_at'];
  }
}
