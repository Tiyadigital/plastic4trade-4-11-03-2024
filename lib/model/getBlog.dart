class GetBlog {
  int? status;
  String? message;
  List<Result>? result;

  GetBlog({this.status, this.message, this.result});

  GetBlog.fromJson(Map<String, dynamic> json) {
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
  int? blogId;
  String? blogTitle;
  Null? shortContent;
  String? longContent;
  String? blogDate;
  String? blogTime;
  String? blogImage;
  String? isLike;
  String? likeCount;
  int? viewCounter;
  int? commentCount;

  Result(
      {this.blogId,
        this.blogTitle,
        this.shortContent,
        this.longContent,
        this.blogDate,
        this.blogTime,
        this.blogImage,
        this.isLike,
        this.likeCount,
        this.viewCounter,
        this.commentCount});

  Result.fromJson(Map<String, dynamic> json) {
    blogId = json['blogId'];
    blogTitle = json['BlogTitle'];
    shortContent = json['ShortContent'];
    longContent = json['LongContent'];
    blogDate = json['BlogDate'];
    blogTime = json['BlogTime'];
    blogImage = json['BlogImage'];
    isLike = json['isLike'];
    likeCount = json['likeCount'];
    viewCounter = json['view_counter'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blogId'] = this.blogId;
    data['BlogTitle'] = this.blogTitle;
    data['ShortContent'] = this.shortContent;
    data['LongContent'] = this.longContent;
    data['BlogDate'] = this.blogDate;
    data['BlogTime'] = this.blogTime;
    data['BlogImage'] = this.blogImage;
    data['isLike'] = this.isLike;
    data['likeCount'] = this.likeCount;
    data['view_counter'] = this.viewCounter;
    data['commentCount'] = this.commentCount;
    return data;
  }
}
