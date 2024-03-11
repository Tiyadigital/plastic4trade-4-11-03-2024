class GetadminNotification {
  int? status;
  String? message;
  List<Result>? result;

  GetadminNotification({this.status, this.message, this.result});

  GetadminNotification.fromJson(Map<String, dynamic> json) {
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
  int? notificationId;
  String? name;
  int? fromUserId;
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
  String? isAdminNotificationTable;
  int? isRead;
  String? time;
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
        this.isAdminNotificationTable,
        this.time,
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
    isAdminNotificationTable = json['is_admin_notification_table'];
    isRead = json['is_read'];
    time = json['time'];
    otherImage = json['other_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationId'] = this.notificationId;
    data['name'] = this.name;
    data['from_user_id'] = this.fromUserId;
    data['profilepic'] = this.profilepic;
    data['heading'] = this.heading;
    data['description'] = this.description;
    data['type'] = this.type;
    data['notification_type'] = this.notificationType;
    data['salepost_id'] = this.salepostId;
    data['buypost_id'] = this.buypostId;
    data['post_image'] = this.postImage;
    data['blog_id'] = this.blogId;
    data['news_id'] = this.newsId;
    data['liveprice_id'] = this.livepriceId;
    data['advertise_id'] = this.advertiseId;
    data['is_admin_notification_table'] = this.isAdminNotificationTable;
    data['is_read'] = this.isRead;
    data['time'] = this.time;
    data['other_image'] = this.otherImage;
    return data;
  }
}
