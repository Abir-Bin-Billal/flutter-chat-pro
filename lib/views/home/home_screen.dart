import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:flutter_chat_pro/views/chat/my_chat_screen.dart';
import 'package:flutter_chat_pro/views/group/group_list_screen.dart';
import 'package:flutter_chat_pro/views/people/people_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  final List<Widget> _pages = [
    MyChatScreen(),
    GroupListScreen(),
    PeopleScreen(),
  ];


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
   switch (state) {
      case AppLifecycleState.resumed:
        context.read<AuthenticationProvider>().updateUserStatus(value: true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        context.read<AuthenticationProvider>().updateUserStatus(value: false);
        break;
        default:
          break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authProvider = context
        .read<AuthenticationProvider>();
    final userModel = authProvider.userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chat Pro"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppConst.profileScreen,
                  arguments: authProvider.userModel!.uid,
                );
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: userModel!.image.isNotEmpty
                    ? MemoryImage(base64Decode(userModel.image))
                    : const AssetImage("assets/images/user.png")
                          as ImageProvider,
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chats",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "People"),
        ],
      ),
    );
  }
}
