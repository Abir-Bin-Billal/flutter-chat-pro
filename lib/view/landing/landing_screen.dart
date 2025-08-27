import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    checkAuthentication();
    super.initState();
  }

  void checkAuthentication() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    bool isSignedIn = await authenticationProvider.checkAuthenticationState();
    if (isSignedIn) {
      Navigator.pushReplacementNamed(context, AppConst.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppConst.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 400,
          width: 200,
          child: Column(
            children: [
              Lottie.asset('assets/lottie/chat_bubble.json'),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
