import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/providers/chat_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:provider/provider.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key});

  @override
  State<MyChatScreen> createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel?.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            CupertinoSearchTextField(
              onChanged: (value) {},
              placeholder: "Search friends...",
              padding: const EdgeInsets.all(10),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Expanded(
              child: StreamBuilder(
                stream: context.read<ChatProvider>().getChatListSteam(uid!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return const Center(child: Text("No chats available"));
                  }
                  final data = snapshot.data as List;
                  ;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final chat = data[index];
                      final isMe = chat.senderUID == uid;
                      final lastMessage = isMe
                          ? "You: ${chat.message}"
                          : chat.message;
                      final dateTime = formatDate(chat.timeSent, [
                        hh,
                        ':',
                        nn,
                        ' ',
                        am,
                      ]);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: MemoryImage(
                            base64Decode(chat.contactImage),
                          ),
                        ),
                        title: Text(chat.contactName),
                        subtitle: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(dateTime),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppConst.chatScreen,
                            arguments: {
                              'contactUID': chat.contactUID,
                              'contactName': chat.contactName,
                              'contactImage': chat.contactImage,
                              'groupId': "",
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
