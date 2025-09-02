import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class GroupChatAppBar extends StatefulWidget {
  const GroupChatAppBar({super.key, required this.groupId});
  final String groupId;

  @override
  State<GroupChatAppBar> createState() => _GroupChatAppBarState();
}

class _GroupChatAppBarState extends State<GroupChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthenticationProvider>().getUserStream(
        userID: widget.groupId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }
        if (!snapshot.hasData) {
          return Center(child: Text("User not found"));
        }
        final userModel = UserModel.fromJson(
          snapshot.data!.data() as Map<String, dynamic>,
        );
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: userModel.image != null
                  ? MemoryImage(base64Decode(userModel.image))
                  : null,
              child: userModel.image == null
                  ? Icon(Icons.person, size: 80)
                  : null,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Online",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}