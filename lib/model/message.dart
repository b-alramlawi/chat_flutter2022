import 'package:flutter/cupertino.dart';

class MessageObject {
  final String sender;
  final String text;
  final String time;
  final bool isMe;
  final BuildContext context;
  final List<dynamic> imagesList;
  final Function onDeleteMessage;

  MessageObject({
    this.sender,
    this.text,
    this.time,
    this.isMe,
    this.context,
    this.imagesList,
    this.onDeleteMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "time": time,
      "isMe": isMe,
      "context": context,
      "imagesList": imagesList,
      "onDeleteMessage": onDeleteMessage,
    };
  }

  factory MessageObject.fromMap(Map<String, dynamic> data) {
    return MessageObject(
      sender: data["sender"],
      text: data["text"],
      time: data["time"],
      isMe: data["isMe"],
      context: data["context"],
      imagesList: List.from(data["imagesList"] ?? []),
      onDeleteMessage: data["onDeleteMessage"],
    );
  }
}
