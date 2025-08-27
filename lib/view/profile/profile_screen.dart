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
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
  if (currentUser != null && currentUser.uid == uid)
    IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    await context.read<AuthenticationProvider>().logOut();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppConst.landingScreen,
                      (route) => false,
                    );
                  },
                  child: Text("Logout"),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(Icons.logout),
    ),
],

      ),
      body: uid == null
    ? Center(child: Text("No user selected"))
    : StreamBuilder(
        stream: context.read<AuthenticationProvider>().getUserStream(userID: uid!),
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
          final userModel = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return ListTile(
            leading: CircleAvatar(
  backgroundImage: userModel.image.isNotEmpty
      ? MemoryImage(base64Decode(userModel.image))
      : const AssetImage("assets/images/user.png") as ImageProvider,
),

            title: Text(userModel.name),
            subtitle: Text(userModel.aboutMe),
          );
        },
      ),
    );
  }
}
