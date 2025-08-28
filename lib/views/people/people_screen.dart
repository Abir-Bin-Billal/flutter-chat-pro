import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(
              onChanged: (value) {},
              placeholder: "Search...",
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: context.read<AuthenticationProvider>().getAllUserStream(
                userID: currentUser!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("No users found"));
                }
                if (!snapshot.data!.docs.isNotEmpty) {
                  return Center(
                    child: Text(
                      "No users found",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((
                    DocumentSnapshot document,
                  ) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                      title: Text(
                        data[AppConst.name],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(data[AppConst.aboutMe]),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppConst.profileScreen,
                          arguments: document.id,
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
