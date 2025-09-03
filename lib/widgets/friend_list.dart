import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FriendList extends StatelessWidget {
  const FriendList({super.key, required this.viewType});
  final FriendViewType viewType;

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    final future = viewType == FriendViewType.friends
        ? context.read<AuthenticationProvider>().getFriendsList(uid)
        : viewType == FriendViewType.friendRequests
        ? context.read<AuthenticationProvider>().getFriendRequestsList(uid)
        : context.read<AuthenticationProvider>().getFriendsList(uid);

    return FutureBuilder<List<UserModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No friends found."));
        }

        List<UserModel> friends = snapshot.data!;
        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            UserModel friend = friends[index];
            return ListTile(
              contentPadding: EdgeInsets.only(left: -10),
              leading: CircleAvatar(
                backgroundImage: MemoryImage(base64Decode(friend.image)),
              ),
              title: Text(friend.name),
              subtitle: Text(
                friend.aboutMe,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  if (viewType == FriendViewType.friends) {
                    Navigator.pushNamed(
                      context,
                      AppConst.chatScreen,
                      arguments: {
                        AppConst.contactUID: friend.uid,
                        AppConst.contactName: friend.name,
                        AppConst.contactImage: friend.image,
                      },
                    );
                  } else if (viewType == FriendViewType.friendRequests) {
                    context
                        .read<AuthenticationProvider>()
                        .acceptFriendRequest(friendID: friend.uid)
                        .whenComplete(() {
                          Fluttertoast.showToast(
                            msg: "Friend request accepted",
                          );
                        });
                  }
                },
                child: viewType == FriendViewType.friends
                    ? const Text("Message")
                    : const Text("Accept"),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppConst.profileScreen,
                  arguments: friend.uid,
                );
              },
            );
          },
        );
      },
    );
  }
}
