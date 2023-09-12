class GetNotificationcount {
  int? status;
  String? message;
  int? notificationCount;

  GetNotificationcount({this.status, this.message, this.notificationCount});

  GetNotificationcount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    notificationCount = json['NotificationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['NotificationCount'] = this.notificationCount;
    return data;
  }
}
