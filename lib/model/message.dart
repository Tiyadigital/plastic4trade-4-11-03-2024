class Message {
   String? messageText;
   int? messageTime;
   String? senderId;
   String? mediaType;
   String? mediaName;

  Message(
      { this.messageText,
         this.messageTime,
         this.senderId,
         this.mediaType,
         this.mediaName});
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      //count: json['count'],
      mediaName: json['mediaName'],
      mediaType: json['mediaType'],
      messageText: json['messageText'],
      messageTime: json['messageTime'],
      senderId: json['senderId'],
      //userImage1: json['userImage1'],
      //userImage2: json['userImage2'],
     // userName1: json['userName1'],
     // userName2: json['userName2'],
    );
  }
}