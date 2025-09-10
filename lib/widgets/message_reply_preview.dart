import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class MessageReplyPreview extends StatelessWidget {
  const MessageReplyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageReply = chatProvider.messageReplyModel;
        final isMe = messageReply!.isMe;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30),
              topRight: const Radius.circular(30),
            ),
          ),
          child: ListTile(
            title: Text(
              isMe ? "You" : messageReply.senderName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            subtitle: Text(
              messageReply.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                chatProvider.setMessageReplyModel(null);
              },
            ),
          ),
        );
      },
    );
  }
}
