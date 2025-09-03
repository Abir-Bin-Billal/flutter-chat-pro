import 'package:flutter_chat_pro/utils/app_const.dart';

class MessageReplyModel {
  final String message;
  final String senderUID;
  final String senderName;
  final String senderImage;
  final MessageEnum messageType;
  final bool isMe;

  MessageReplyModel({
    required this.message,
    required this.senderUID,
    required this.senderName,
    required this.senderImage,
    required this.messageType,
    required this.isMe,
  });

  // JSON → Model
  factory MessageReplyModel.fromJson(Map<String, dynamic> json) {
    return MessageReplyModel(
      message: json['message'] ?? '',
      senderUID: json['senderUID'] ?? '',
      senderName: json['senderName'] ?? '',
      senderImage: json['senderImage'] ?? '',
      messageType: _stringToMessageEnum(json['messageType']),
      isMe: json['isMe'] ?? false,
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderUID': senderUID,
      'senderName': senderName,
      'senderImage': senderImage,
      'messageType': messageType.name,
      'isMe': isMe,
    };
  }

  // Convert String → Enum safely
  static MessageEnum _stringToMessageEnum(String? type) {
    if (type == null) return MessageEnum.text;
    return MessageEnum.values.firstWhere(
      (e) => e.name == type,
      orElse: () => MessageEnum.text,
    );
  }
}
