class GetVideoList {
  int? status;
  String? message;
  List<Result>? result;

  GetVideoList({this.status, this.message, this.result});

  GetVideoList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? videoId;
  String? videoTitle;
  String? videoUrl;
  String? videoendUrl;

  Result({this.videoId, this.videoTitle, this.videoUrl, this.videoendUrl});

  Result.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    videoTitle = json['videoTitle'];
    videoUrl = json['videoUrl'];
    videoendUrl = json['videoendUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoId'] = this.videoId;
    data['videoTitle'] = this.videoTitle;
    data['videoUrl'] = this.videoUrl;
    data['videoendUrl'] = this.videoendUrl;
    return data;
  }
}
