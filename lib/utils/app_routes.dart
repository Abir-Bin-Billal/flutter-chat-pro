import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:flutter_chat_pro/views/auth/login_screen.dart';
import 'package:flutter_chat_pro/views/auth/otp_screen.dart';
import 'package:flutter_chat_pro/views/home/home_screen.dart';
import 'package:flutter_chat_pro/views/info/user_information_screen.dart';
import 'package:flutter_chat_pro/views/landing/landing_screen.dart';
import 'package:flutter_chat_pro/views/profile/profile_screen.dart';
import 'package:flutter_chat_pro/views/settings/settings_screen.dart';

class AppRoutes {
  final appRoutes = {
    AppConst.loginScreen: (context) => const LoginScreen(),
    AppConst.otpScreen: (context) =>  OtpScreen(phoneNumber: '', verificationId: '',),
    AppConst.userInformationScreen: (context) => const UserInformationScreen(),
    AppConst.homeScreen: (context) => const HomeScreen(),
    AppConst.landingScreen: (context) => const LandingScreen(),
    AppConst.profileScreen: (context) => const ProfileScreen(),
    AppConst.settingsScreen: (context) => const SettingsScreen(),
  };
}