class GetNewsDetail {
  int? status;
  String? message;
  Result? result;

  GetNewsDetail({this.status, this.message, this.result});

  GetNewsDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? newsId;
  String? newsTitle;
  String? shortContent;
  String? shortDescription;
  String? longContent;
  String? newsDate;
  String? newsTime;
  String? newsImage;
  String? isLike;
  String? likeCount;
  int? viewCounter;
  int? commentCount;

  Result(
      {this.newsId,
        this.newsTitle,
        this.shortContent,
        this.shortDescription,
        this.longContent,
        this.newsDate,
        this.newsTime,
        this.newsImage,
        this.isLike,
        this.likeCount,
        this.viewCounter,
        this.commentCount});

  Result.fromJson(Map<String, dynamic> json) {
    newsId = json['newsId'];
    newsTitle = json['newsTitle'];
    shortContent = json['ShortContent'];
    shortDescription = json['short_description'];
    longContent = json['LongContent'];
    newsDate = json['newsDate'];
    newsTime = json['newsTime'];
    newsImage = json['newsImage'];
    isLike = json['isLike'];
    likeCount = json['likeCount'];
    viewCounter = json['viewCounter'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsId'] = this.newsId;
    data['newsTitle'] = this.newsTitle;
    data['ShortContent'] = this.shortContent;
    data['short_description'] = this.shortDescription;
    data['LongContent'] = this.longContent;
    data['newsDate'] = this.newsDate;
    data['newsTime'] = this.newsTime;
    data['newsImage'] = this.newsImage;
    data['isLike'] = this.isLike;
    data['likeCount'] = this.likeCount;
    data['viewCounter'] = this.viewCounter;
    data['commentCount'] = this.commentCount;
    return data;
  }
}
