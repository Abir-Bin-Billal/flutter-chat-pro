import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  void getThemeMode() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode == AdaptiveThemeMode.dark) {
      setState(() {
        _isDarkMode = true;
      });
    } else {
      setState(() {
        _isDarkMode = false;
      });
    }
  }

  @override
  void initState() {
    getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          if (currentUser != null && currentUser.uid == currentUser.uid)
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
                            await context
                                .read<AuthenticationProvider>()
                                .logOut();
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
      body: Center(
        child: Card(
          child: SwitchListTile(
            value: _isDarkMode,
            title: Text("Change Theme"),
            secondary: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.black : Colors.yellow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.white,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              AdaptiveTheme.of(context).setThemeMode(
                _isDarkMode ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
              );
            },
          ),
        ),
      ),
    );
  }
}
