import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart' hide Size;
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/widgets/loading_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country _selectedCountry = Country(
    phoneCode: "+880",
    countryCode: "BD",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Bangladesh",
    example: "bangladesh",
    displayName: "BD",
    displayNameNoCountryCode: "BD",
    e164Key: "",
  );
  @override
  Widget build(BuildContext context) {
    final AuthenticationProvider authenticationProvider = context
        .watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset("assets/lottie/chat_bubble.json"),
            ),
            Text(
              "Welcome to Flutter Chat Pro",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "Add your phone number to verify",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: EdgeInsets.only(left: 7, top: 15, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,

                          onSelect: (Country country) {
                            setState(() {
                              _selectedCountry = country;
                            });
                          },
                        );
                      },
                      child: Text(
                        "${_selectedCountry.flagEmoji}${_selectedCountry.phoneCode}",
                      ),
                    ),
                  ),
                  counterText: "",
                  hintText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 0),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () async {
                  print(
                    " Number is :${_selectedCountry.phoneCode}${phoneController.text}",
                  );
                  authenticationProvider.signInWithPhoneNumber(
                    phoneNumber:
                        "${_selectedCountry.phoneCode}${phoneController.text}",
                    context: context,
                  );
                },
                child: authenticationProvider.isLoading
                    ? LoadingView()
                    : Text("Verify"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
