import 'package:flutter_chat_pro/utils/app_const.dart';

class LastMessageModel {
  final String senderUID;
  final String contactUID;
  final String contactName;
  final String contactImage;
  final String message;
  final MessageEnum messageType;
  final DateTime timeSent;
  final bool isSeen;

  LastMessageModel({
    required this.senderUID,
    required this.contactUID,
    required this.contactName,
    required this.contactImage,
    required this.message,
    required this.messageType,
    required this.timeSent,
    required this.isSeen,
  });

  // ✅ to Map
  Map<String, dynamic> toJson() {
    return {
      'senderUID': senderUID,
      'contactUID': contactUID,
      'contactName': contactName,
      'contactImage': contactImage,
      'message': message,
      'messageType': messageType.name, // ✅ save as string
      'timeSent': timeSent.millisecondsSinceEpoch, // ✅ better for Firestore
      'isSeen': isSeen,
    };
  }

  // ✅ JSON → Model
  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      senderUID: json['senderUID'] ?? '',
      contactUID: json['contactUID'] ?? '',
      contactName: json['contactName'] ?? '',
      contactImage: json['contactImage'] ?? '',
      message: json['message'] ?? '',
      messageType: _stringToMessageEnum(json['messageType']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(
        json['timeSent'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isSeen: json['isSeen'] ?? false,
    );
  }

  // ✅ copyWith
  LastMessageModel copyWith({
    String? contactUID,
    String? contactName,
    String? contactImage,
  }) {
    return LastMessageModel(
      senderUID: senderUID,
      contactUID: contactUID ?? this.contactUID,
      contactName: contactName ?? this.contactName,
      contactImage: contactImage ?? this.contactImage,
      message: message,
      messageType: messageType,
      timeSent: timeSent,
      isSeen: isSeen,
    );
  }

  // ✅ Helper to parse enum from string
  static MessageEnum _stringToMessageEnum(dynamic type) {
    if (type is String) {
      return MessageEnum.values.firstWhere(
        (e) => e.name == type,
        orElse: () => MessageEnum.text,
      );
    }
    return MessageEnum.text;
  }
}
