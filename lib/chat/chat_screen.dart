import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/providers/chat_provider.dart';
import 'package:flutter_chat_pro/widgets/bottom_chat_field.dart';
import 'package:flutter_chat_pro/widgets/chat_app_bar.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final contactUID = args[AppConst.contactUID];
    final contactName = args[AppConst.contactName];
    final contactImage = args[AppConst.contactImage];
    final groupId = args[AppConst.groupId];

    final bool isGroupChat = groupId != null && groupId.isNotEmpty;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: ChatAppBar(contactUID: contactUID),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: context.read<ChatProvider>().getMessageStream(
                  userId: uid,
                  contactUID: contactUID,
                  isGroup: groupId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }
                  final messages = snapshot.data as List;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderUID == uid;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message.message,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            BottomChatField(
              contactUID: contactUID ?? "",
              groupId: groupId ?? "",
              contactName: contactName ?? "Unknown",
              contactImage: contactImage ?? "",
            ),
          ],
        ),
      ),
    );
  }
}
