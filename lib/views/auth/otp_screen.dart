import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });
  final String phoneNumber;
  final String verificationId;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  void verifyOtp({required String verificationId, required String otp}) async {
    final authProvider = context.read<AuthenticationProvider>();
    await authProvider.verifyOTP(
      verificationId: verificationId,
      otp: otp,
      context: context,
      onSuccess: () async {
        bool userExist = await authProvider.checkUserExist();
        print("User exist: $userExist");

        if (userExist) {
          // Existing user → go to home
          await authProvider.getUserDataFromFirestore();
          await authProvider.saveUserDataToSecureStorage();
          Navigator.pushReplacementNamed(context, AppConst.homeScreen);
        } else {
          // First-time user → go to user information screen
          Navigator.pushReplacementNamed(
            context,
            AppConst.userInformationScreen,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //get the args
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String verificationId = args['verificationId']!;
    final String phoneNumber = args['phoneNumber']!;
    final AuthenticationProvider authenticationProvider = context
        .watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OTP verfication",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text("Enter the code that has sent to $phoneNumber "),
            SizedBox(height: 10),
            Pinput(
              length: 6,
              showCursor: true,
              onCompleted: (String pin) {
                print("Entered OTP: $pin");
                verifyOtp(verificationId: verificationId, otp: pin);
              },
              defaultPinTheme: PinTheme(
                height: 56,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
              ),
              errorPinTheme: PinTheme(
                height: 56,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: TextStyle(fontSize: 20, color: Colors.red),
              ),
              focusedPinTheme: PinTheme(
                height: 56,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            authenticationProvider.isSuccessful
                ? Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.done, color: Colors.white, size: 30),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 5),
            authenticationProvider.isLoading
                ? SizedBox.shrink()
                : Text(
                    "Didn't receive the OTP? Resend",
                    style: TextStyle(color: Colors.blue),
                  ),
          ],
        ),
      ),
    );
  }
}
