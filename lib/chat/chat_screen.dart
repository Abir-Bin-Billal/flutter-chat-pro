import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/providers/chat_provider.dart';
import 'package:flutter_chat_pro/widgets/bottom_chat_field.dart';
import 'package:flutter_chat_pro/widgets/chat_app_bar.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:grouped_list/grouped_list.dart';
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
                    groupHeaderBuilder: (dynamic groupedByValue) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formatDate(groupedByValue.timeSent!, [
                          dd,
                          ' ',
                          M,
                          ', ',
                          yy,
                        ]), // Example: Sep 4
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    itemBuilder: (context, dynamic element) {
                      final isMe = element.senderUID == uid;
                      final dateTime = formatDate(element.timeSent!, [
                        hh,
                        ':',
                        nn,
                        ' ',
                        am,
                      ]);
                      return Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isMe ? Colors.blue : Colors.grey.shade200,
                            ),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  element.message ?? '',
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  dateTime,
                                  style: TextStyle(
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
