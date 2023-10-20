class Message {
  String? messageText;
  int? messageTime;
  String? senderId;
  String? mediaType;
  String? mediaName;


  Message(
  {this.messageText,
      this.messageTime,
      this.senderId,
      this.mediaType,
      this.mediaName});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      mediaName: json['mediaName'],
      mediaType: json['mediaType'],
      messageText: json['messageText'],
      messageTime: json['messageTime'],
      senderId: json['senderId'],
    );
  }
}
