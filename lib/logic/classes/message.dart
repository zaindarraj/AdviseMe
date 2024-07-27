import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  FieldValue? server_time;
  Timestamp? time_stamp;
  String message;
  String sender_id;
  String type;
  String? imagePlaceHolder;
  Message(
      {required this.message,
      required this.type,
      this.server_time,
      this.time_stamp,
      required this.sender_id,
      this.imagePlaceHolder});

  Message.fromJson(Map<String, dynamic> json)
      : this(
            type: json["type"],
            imagePlaceHolder: json["imagePlaceHolder"],
            message: json["message"],
            time_stamp: json["time_stamp"],
            sender_id: json["sender_id"]);

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "imagePlaceHolder": imagePlaceHolder,
      "message": message,
      "sender_id": sender_id,
      "time_stamp": server_time
    };
  }
}
