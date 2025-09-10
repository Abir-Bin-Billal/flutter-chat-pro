import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/message_model.dart';
import 'package:flutter_chat_pro/models/message_reply_model.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/providers/chat_provider.dart';
import 'package:flutter_chat_pro/utils/global_methods.dart';
import 'package:flutter_chat_pro/widgets/contact_message_widget.dart';
import 'package:flutter_chat_pro/widgets/my_message_widget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.contactUID, required this.groupId});
  final String contactUID;
  final String groupId;
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    return StreamBuilder<List<MessageModel>>(
      stream: context.read<ChatProvider>().getMessageStream(
        userId: uid,
        contactUID: widget.contactUID,
        isGroup: widget.groupId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(
            child: Text(
              "Start a conversation",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }
        final messagesList = snapshot.data as List;
        return GroupedListView<dynamic, DateTime>(
          elements: messagesList,
          reverse: true,
          groupBy: (message) => DateTime(
            message.timeSent.year,
            message.timeSent.month,
            message.timeSent.day,
          ),
          groupHeaderBuilder: (dynamic groupedByValue) =>
              SizedBox(
                height: 40,
                child: buildDateTime(groupedByValue)),
          itemBuilder: (context, dynamic element) {
            final isMe = element.senderUID == uid;
            return isMe
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: MyMessageWidget(
                      message: element,
                      onRightSwipe: (message) {
                        final messageReply = MessageReplyModel(
                          senderUID: message.senderUID,
                          message: message.message,
                          senderName: context
                              .read<AuthenticationProvider>()
                              .userModel!
                              .name,
                          isMe: true,
                          senderImage: element.senderImage,
                          messageType: element.messageType,
                        );
                        context.read<ChatProvider>().setMessageReplyModel(
                          messageReply,
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: ContactMessageWidget(
                      message: element,
                      onRightSwipe: () {
                        final messageReply = MessageReplyModel(
                          senderUID: element.senderUID,
                          message: element.message,
                          senderName: context
                              .read<AuthenticationProvider>()
                              .userModel!
                              .name,
                          isMe: true,
                          senderImage: element.senderImage,
                          messageType: element.messageType,
                        );
                        context.read<ChatProvider>().setMessageReplyModel(
                          messageReply,
                        );
                      },
                    ),
                  );
          },
          itemComparator: (item1, item2) {
            return item2.timeSent.compareTo(item1.timeSent);
          },
          groupComparator: (item1, item2) => item2.compareTo(item1),
          useStickyGroupSeparators: true,
          floatingHeader: true,
          order: GroupedListOrder.ASC,
        );
      },
    );
  }
}
