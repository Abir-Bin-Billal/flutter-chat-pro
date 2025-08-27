import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
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
          currentUser!.uid == uid
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppConst.settingsScreen,
                      arguments: uid,
                    );
                  },
                  icon: Icon(Icons.settings),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: uid == null
          ? Center(child: Text("No user selected"))
          : StreamBuilder(
              stream: context.read<AuthenticationProvider>().getUserStream(
                userID: uid!,
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
                              ? MemoryImage(base64Decode(userModel.image!))
                              : null,
                          child: userModel.image == null
                              ? Icon(Icons.person, size: 80)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userModel.name ?? "Unknown User",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildFriendRequestButton(
                      userModel: userModel,
                      currentUser: currentUser!,
                    ),
                    const SizedBox(height: 10),
                    buildFriendButton(
                      userModel: userModel,
                      currentUser: currentUser,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userModel.phoneNumber ?? "No information available",
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
                      userModel.aboutMe ?? "No information available",
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
    required UserModel currentUser,
  }) {
    if (currentUser.uid == userModel.uid &&
        userModel.friendRequestsUIDs.isNotEmpty) {
      return buildElevatedButton(
        onPressed: () {},
        text: "View Friend Requests",
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildFriendButton({
    required UserModel userModel,
    required UserModel currentUser,
  }) {
    if (currentUser.uid == userModel.uid && userModel.friendsUIDs.isNotEmpty) {
      return buildElevatedButton(onPressed: () {}, text: "View Friends");
    } else {
      if (currentUser.uid != userModel.uid) {
        return buildElevatedButton(
          onPressed: () {},
          text: "Send Friend Request",
        );
      } else {
        return SizedBox.shrink();
      }
    }
  }

  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
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
