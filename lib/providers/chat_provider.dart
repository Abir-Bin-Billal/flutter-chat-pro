import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/last_message_model.dart';
import 'package:flutter_chat_pro/models/message_model.dart';
import 'package:flutter_chat_pro/models/message_reply_model.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  MessageReplyModel? _messageReplyModel;
  MessageReplyModel? get messageReplyModel => _messageReplyModel;

  void setMessageReplyModel(MessageReplyModel? messageReply) {
    _messageReplyModel = messageReply;
    notifyListeners();
  }
  void clearMessageReply() {
    _messageReplyModel = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> sendTextMessage({
    required UserModel sender,
    required String message,
    required String contactUID,
    required String contactName,
    required String contactImage,
    required MessageEnum messageType,
    required String groupId,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      var messageId = Uuid().v4();

      String repliedMessage = _messageReplyModel?.message ?? '';
      String repliedTo = _messageReplyModel?.senderName ?? '';
      MessageEnum repliedMessageType =
          _messageReplyModel?.messageType ?? MessageEnum.text;

      final messageModel = MessageModel(
        senderUID: sender.uid,
        senderName: sender.name,
        senderImage: sender.image,
        message: message,
        messageType: messageType,
        timeSent: DateTime.now(),
        messageId: messageId,
        contactUID: contactUID,
        isSeen: false,
        repliedMessage: repliedMessage,
        repliedTo: repliedTo,
        repliedMessageType: repliedMessageType,
      );
      if (groupId.isEmpty) {
        await handleContactMessage(
          messageModel: messageModel,
          contactUID: contactUID,
          contactName: contactName,
          contactImage: contactImage,
          onSuccess: onSuccess,
          onError: onError,
        );
        setMessageReplyModel(null);
        onSuccess();
      } else {
        await handleContactMessage(
          messageModel: messageModel,
          contactUID: contactUID,
          contactName: contactName,
          contactImage: contactImage,
          onSuccess: onSuccess,
          onError: onError,
        );
        setMessageReplyModel(null);
        onSuccess();
      }
    } catch (e) {
      onError(e.toString());
      print("Error in sendTextMessage: $e");
    }
  }

  Future<void> handleContactMessage({
    required MessageModel messageModel,
    required String contactUID,
    required String contactName,
    required contactImage,
    required Function onSuccess,
    required Function(String p1) onError,
  }) async {
    try {
      final contactMessageModel = messageModel.copyWith(
        userId: messageModel.senderUID,
      );

      final sendLastMessage = LastMessageModel(
        senderUID: messageModel.senderUID,
        contactUID: contactUID,
        contactName: contactName,
        contactImage: contactImage,
        message: messageModel.message,
        messageType: messageModel.messageType,
        timeSent: messageModel.timeSent,
        isSeen: false,
      );

      final contactLastMessage = sendLastMessage.copyWith(
        contactUID: messageModel.senderUID,
        contactName: messageModel.senderName,
        contactImage: messageModel.senderImage,
      );

      // run transaction

      await _firestore.runTransaction((transaction) async {
        // Sender’s chat messages
        transaction.set(
          _firestore
              .collection(AppConst.users)
              .doc(messageModel.senderUID)
              .collection(AppConst.chats)
              .doc(contactUID)
              .collection(AppConst.messages)
              .doc(messageModel.messageId),
          messageModel.toJson(),
        );

        // Receiver’s chat messages
        transaction.set(
          _firestore
              .collection(AppConst.users)
              .doc(contactUID)
              .collection(AppConst.chats)
              .doc(messageModel.senderUID)
              .collection(AppConst.messages)
              .doc(messageModel.messageId),
          contactMessageModel.toJson(),
        );

        // Update sender’s last message
        transaction.set(
          _firestore
              .collection(AppConst.users)
              .doc(messageModel.senderUID)
              .collection(AppConst.chats)
              .doc(contactUID),
          sendLastMessage.toJson(),
        );

        // Update receiver’s last message
        transaction.set(
          _firestore
              .collection(AppConst.users)
              .doc(contactUID)
              .collection(AppConst.chats)
              .doc(messageModel.senderUID),
          contactLastMessage.toJson(),
        );
      });
    } catch (e) {
      onError(e.toString());
      print("Error in handleContactMessage: $e");
    }
  }

  Stream<List<LastMessageModel>> getChatListSteam(String userId) {
    return _firestore
        .collection(AppConst.users)
        .doc(userId)
        .collection(AppConst.chats)
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LastMessageModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<MessageModel>> getMessageStream({
    required String userId,
    required String contactUID,
    required String isGroup,
  }) {
    if (isGroup.isNotEmpty) {
      return _firestore
          .collection(AppConst.groups)
          .doc(contactUID)
          .collection(AppConst.messages)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => MessageModel.fromJson(doc.data()))
                .toList(),
          );
    } else {
      return _firestore
          .collection(AppConst.users)
          .doc(userId)
          .collection(AppConst.chats)
          .doc(contactUID)
          .collection(AppConst.messages)
          .orderBy('timeSent', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => MessageModel.fromJson(doc.data()))
                .toList(),
          );
    }
  }
}
