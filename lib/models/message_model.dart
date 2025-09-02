import 'package:flutter_chat_pro/utils/app_const.dart';

class MessageModel {
  final String senderUID;
  final String senderName;
  final String senderImage;
  final String contactUID;
  final String message;
  final MessageEnum messageType;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.senderUID,
    required this.senderName,
    required this.senderImage,
    required this.contactUID,
    required this.message,
    required this.messageType,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  // Convert JSON → Model
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderUID: json['senderUID'] ?? '',
      senderName: json['senderName'] ?? '',
      senderImage: json['senderImage'] ?? '',
      contactUID: json['contactUID'] ?? '',
      message: json['message'] ?? '',
      messageType: _stringToMessageEnum(json['messageType']),
      timeSent: DateTime.tryParse(json['timeSent'] ?? '') ?? DateTime.now(),
      messageId: json['messageId'] ?? '',
      isSeen: json['isSeen'] ?? false,
      repliedMessage: json['repliedMessage'] ?? '',
      repliedTo: json['repliedTo'] ?? '',
      repliedMessageType: _stringToMessageEnum(json['repliedMessageType']),
    );
  }

  // Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'senderUID': senderUID,
      'senderName': senderName,
      'senderImage': senderImage,
      'contactUID': contactUID,
      'message': message,
      'messageType': messageType.name, // store enum as string
      'timeSent': timeSent.toIso8601String(),
      'messageId': messageId,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.name,
    };
  }

  // Helper to parse enum from string
  static MessageEnum _stringToMessageEnum(String? type) {
    if (type == null) return MessageEnum.text;
    return MessageEnum.values.firstWhere(
      (e) => e.name == type,
      orElse: () => MessageEnum.text,
    );
  }
}
