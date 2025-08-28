// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;
    final uid = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          currentUser != null && currentUser.uid == uid
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppConst.settingsScreen,
                      arguments: uid,
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: uid == null
          ? Center(child: Text("No user selected"))
          : StreamBuilder(
              stream: context.read<AuthenticationProvider>().getUserStream(
                userID: uid,
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
                return Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 30.0,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: userModel.image != null
                              ? MemoryImage(base64Decode(userModel.image))
                              : null,
                          child: userModel.image == null
                              ? Icon(Icons.person, size: 80)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userModel.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildFriendRequestButton(
                      userModel: userModel,
                      currentUser: currentUser,
                    ),
                    const SizedBox(height: 10),
                    buildFriendButton(
                      userModel: userModel,
                      currentUser: currentUser,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userModel.phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 60,
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "About Me",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 40,
                          width: 60,
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                      ],
                    ),
                    Text(
                      userModel.aboutMe,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget buildFriendRequestButton({
    required UserModel userModel,
    UserModel? currentUser,
  }) {
    if (currentUser != null &&
        currentUser.uid == userModel.uid &&
        userModel.friendRequestsUIDs.isNotEmpty) {
      return buildElevatedButton(
        width: MediaQuery.of(context).size.width * 0.7,
        onPressed: () {},
        text: "View Friend Requests",
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildFriendButton({
    required UserModel userModel,
    required UserModel? currentUser,
  }) {
    if (currentUser != null &&
        currentUser.uid == userModel.uid &&
        userModel.friendsUIDs.isNotEmpty) {
      return buildElevatedButton(
        width: MediaQuery.of(context).size.width * 0.7,
        onPressed: () {},
        text: "View Friends",
      );
    } else {
      if (currentUser?.uid != userModel.uid) {
        if (userModel.friendsUIDs.contains(currentUser!.uid)) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildElevatedButton(
                width: MediaQuery.of(context).size.width * 0.4,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Unfriend ${userModel.name}?"),
                        content: Text(
                          "Are you sure you want to unfriend this user?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await context
                                  .read<AuthenticationProvider>()
                                  .removeFriend(friendID: userModel.uid)
                                  .whenComplete(() {
                                    Fluttertoast.showToast(
                                      msg: "Unfriended ${userModel.name}",
                                    );
                                  });
                              Navigator.of(context).pop();
                            },
                            child: Text("Unfriend"),
                          ),
                        ],
                      );
                    },
                  );
                },
                text: "Unfriend",
              ),

              buildElevatedButton(
                width: MediaQuery.of(context).size.width * 0.4,
                onPressed: () {},
                text: "Chat",
              ),
            ],
          );
        } else if (userModel.sentFriendRequestsUIDs.contains(currentUser.uid)) {
          return buildElevatedButton(
            width: MediaQuery.of(context).size.width * 0.7,
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .acceptFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                    Fluttertoast.showToast(
                      msg: "You are now friend with ${userModel.name}",
                    );
                  });
            },
            text: "Accept Friend Request",
          );
        } else if (userModel.friendRequestsUIDs.contains(currentUser.uid)) {
          return buildElevatedButton(
            width: MediaQuery.of(context).size.width * 0.7,
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .cancelFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                    Fluttertoast.showToast(msg: "Friend request canceled");
                  });
            },
            text: "Cancel Friend Request",
          );
        } else {
          return buildElevatedButton(
            width: MediaQuery.of(context).size.width * 0.7,
            onPressed: () async {
              await context
                  .read<AuthenticationProvider>()
                  .sendFriendRequest(friendID: userModel.uid)
                  .whenComplete(() {
                    Fluttertoast.showToast(msg: "Friend request sent");
                  });
            },
            text: "Send Friend Request",
          );
        }
      } else {
        return SizedBox.shrink();
      }
    }
  }

  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String text,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
