import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatefulWidget {
  const ChatAppBar({super.key, required this.contactUID});
  final String contactUID;

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthenticationProvider>().getUserStream(
        userID: widget.contactUID,
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
              backgroundImage: MemoryImage(base64Decode(userModel.image)),
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
