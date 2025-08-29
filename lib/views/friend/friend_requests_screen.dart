import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:flutter_chat_pro/widgets/friend_list.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Friend Requests"),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          CupertinoSearchTextField(
            onChanged: (value) {},
            placeholder: "Search...",
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Expanded(child: FriendList(viewType: FriendViewType.friendRequests)),
        ],
      ),
    );
  }
}
