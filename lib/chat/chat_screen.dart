import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/widgets/bottom_chat_field.dart';
import 'package:flutter_chat_pro/widgets/chat_app_bar.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final contactId = args[AppConst.contactId];
    final contactName = args[AppConst.contactName];
    final contactImage = args[AppConst.contactImage];
    final groupId = args[AppConst.groupId];

    final bool isGroupChat = groupId != null && groupId.isNotEmpty;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: ChatAppBar(contactUID: contactId)),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(title: Text("Message $index"));
                },
              ),
            ),
            BottomChatField(
              contactId: contactId,
              groupId: groupId,
              contactName: contactName,
              contactImage: contactImage,
            ),
          ],
        ),
      ),
    );
  }
}
