import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:flutter_chat_pro/widgets/friend_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Friends"),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
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
            Expanded(child: FriendList(viewType: FriendViewType.friends)),
          ],
        ),
      ),
    );
  }
}
