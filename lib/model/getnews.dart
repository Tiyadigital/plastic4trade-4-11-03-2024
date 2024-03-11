class GetNews {
  int? status;
  String? message;
  List<Result>? result;

  GetNews({this.status, this.message, this.result});

  GetNews.fromJson(Map<String, dynamic> json) {
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
  int? newsId;
  String? newsTitle;
  Null shortContent;
  String? longContent;
  String? newsDate;
  String? newsTime;
  String? newsImage;
  String? isLike;
  String? likeCount;
  int? commentCount;
  int? viewCounter;

  Result(
      {this.newsId,
        this.newsTitle,
        this.shortContent,
        this.longContent,
        this.newsDate,
        this.newsTime,
        this.newsImage,
        this.isLike,
        this.likeCount,
        this.commentCount,
        this.viewCounter});

  Result.fromJson(Map<String, dynamic> json) {
    newsId = json['newsId'];
    newsTitle = json['newsTitle'];
    shortContent = json['ShortContent'];
    longContent = json['LongContent'];
    newsDate = json['newsDate'];
    newsTime = json['newsTime'];
    newsImage = json['newsImage'];
    isLike = json['isLike'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    viewCounter = json['viewCounter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsId'] = this.newsId;
    data['newsTitle'] = this.newsTitle;
    data['ShortContent'] = this.shortContent;
    data['LongContent'] = this.longContent;
    data['newsDate'] = this.newsDate;
    data['newsTime'] = this.newsTime;
    data['newsImage'] = this.newsImage;
    data['isLike'] = this.isLike;
    data['likeCount'] = this.likeCount;
    data['commentCount'] = this.commentCount;
    data['viewCounter'] = this.viewCounter;
    return data;
  }
}
