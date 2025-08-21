import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:flutter_chat_pro/view/auth/login_screen.dart';
import 'package:flutter_chat_pro/view/auth/otp_screen.dart';
import 'package:flutter_chat_pro/view/home/home_screen.dart';
import 'package:flutter_chat_pro/view/info/user_information_screen.dart';

class AppRoutes {
  final appRoutes = {
    AppConst.loginScreen: (context) => const LoginScreen(),
    AppConst.otpScreen: (context) =>  OtpScreen(phoneNumber: '', verificationId: '',),
    AppConst.userInformationScreen: (context) => const UserInformationScreen(),
    AppConst.homeScreen: (context) => const HomeScreen(),
  };
}