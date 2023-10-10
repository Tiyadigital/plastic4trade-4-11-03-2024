// ignore_for_file: camel_case_types

class chat_userlist {
  String? count;
  String? mediaName;
  String? mediaType;
  String? messageText;
  int? messageTime;
  String? senderId;
  String? userImage1;
  String? userImage2;
  String? userName1;
  String? userName2;

  chat_userlist({
      this.count,
     this.mediaName,
     this.mediaType,
     this.messageText,
     this.messageTime,
     this.senderId,
     this.userImage1,
     this.userImage2,
     this.userName1,
     this.userName2,
  });

  factory chat_userlist.fromJson(Map<String, dynamic> json) {
    return chat_userlist(
      count: json['count'],
      mediaName: json['mediaName'],
      mediaType: json['mediaType'],
      messageText: json['messageText'],
      messageTime: json['messageTime'],
      senderId: json['senderId'],
      userImage1: json['userImage1'],
      userImage2: json['userImage2'],
      userName1: json['userName1'],
      userName2: json['userName2'],
    );
  }
}
