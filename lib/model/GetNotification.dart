class GetNotification {
  int? status;
  String? message;
  int? notificationCount;
  List<Result>? result;

  GetNotification(
      {this.status, this.message, this.notificationCount, this.result});

  GetNotification.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json[''
        'message'];
    notificationCount = json['NotificationCount'];
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
    data['NotificationCount'] = notificationCount;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? notificationId;
  String? name;
  String? fromUserId;
  String? profilepic;
  String? heading;
  String? description;
  String? type;
  String? notificationType;
  String? salepostId;
  String? buypostId;
  String? postImage;
  String? blogId;
  String? newsId;
  String? livepriceId;
  String? advertiseId;
  String? isRead;
  String? time;
  String? profileUserId;
  String? isFollow;
  String? followId;
  String? otherImage;

  Result(
      {this.notificationId,
        this.name,
        this.fromUserId,
        this.profilepic,
        this.heading,
        this.description,
        this.type,
        this.notificationType,
        this.salepostId,
        this.buypostId,
        this.postImage,
        this.blogId,
        this.newsId,
        this.livepriceId,
        this.advertiseId,
        this.isRead,
        this.time,
        this.profileUserId,
        this.isFollow,
        this.followId,
        this.otherImage});

  Result.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    name = json['name'];
    fromUserId = json['from_user_id'];
    profilepic = json['profilepic'];
    heading = json['heading'];
    description = json['description'];
    type = json['type'];
    notificationType = json['notification_type'];
    salepostId = json['salepost_id'];
    buypostId = json['buypost_id'];
    postImage = json['post_image'];
    blogId = json['blog_id'];
    newsId = json['news_id'];
    livepriceId = json['liveprice_id'];
    advertiseId = json['advertise_id'];
    isRead = json['is_read'];
    time = json['time'];
    profileUserId = json['profile_user_id'];
    isFollow = json['is_follow'];
    followId = json['follow_id'];
    otherImage = json['other_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['name'] = name;
    data['from_user_id'] = fromUserId;
    data['profilepic'] = profilepic;
    data['heading'] = heading;
    data['description'] = description;
    data['type'] = type;
    data['notification_type'] = notificationType;
    data['salepost_id'] = salepostId;
    data['buypost_id'] = buypostId;
    data['post_image'] = postImage;
    data['blog_id'] = blogId;
    data['news_id'] = newsId;
    data['liveprice_id'] = livepriceId;
    data['advertise_id'] = advertiseId;
    data['is_read'] = isRead;
    data['time'] = time;
    data['profile_user_id'] = profileUserId;
    data['is_follow'] = isFollow;
    data['follow_id'] = followId;
    data['other_image'] = otherImage;
    return data;
  }
}
