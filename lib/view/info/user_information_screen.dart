import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/providers/authentication_provider.dart';
import 'package:flutter_chat_pro/providers/image_picker_provider.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePickerProvider _imagePickerProvider = ImagePickerProvider();
  File? finalFileImage;
  String userImage = '';

  void selectImage(bool fromCamera) async {
    final pickedFile = await _imagePickerProvider.pickImage(
      fromCamera: fromCamera,
      onFail: (error) {
        Fluttertoast.showToast(
          msg: "Error picking image: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
    );

    if (pickedFile != null) {
      // First assign the file
      setState(() {
        finalFileImage = pickedFile;
      });
    }
  }

  void showBottomSheet() {
    showAboutDialog(
      context: context,
      children: [
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('Camera'),
          onTap: () {
            Navigator.pop(context);
            selectImage(true);
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Gallery'),
          onTap: () {
            Navigator.pop(context);
            selectImage(false);
          },
        ),
      ],
    );
  }

  void saveUserDataToFireStore() async {
    final authProvider = context.read<AuthenticationProvider>();
    UserModel userModel = UserModel(
      uid: authProvider.uid!,
      name: _nameController.text.trim(),
      phoneNumber: authProvider.phoneNumber!,
      image: userImage,
      token: '',
      aboutMe: 'Hey there! I am using Flutter Chat Pro',
      lastSeen: '',
      createdAt: '',
      isOnline: true,
      friendsUIDs: [],
      friendRequestsUIDs: [],
      sentFriendRequestsUIDs: [],
    );
    if (finalFileImage == null || !finalFileImage!.existsSync()) {
  Fluttertoast.showToast(msg: "Please select an image first!");
  return;
}
    authProvider.saveUserDataToFireStore(
      userModel: userModel,
      fileImage: finalFileImage,
      onSuccess: () {
        Fluttertoast.showToast(
          msg: "User information updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        authProvider.saveUserDataToSecureStorage();
        navigateToHomeScreen();
      },
      onError: (error) {
        Fluttertoast.showToast(
          msg: "Error updating user information: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      },
    );
  }

  void navigateToHomeScreen() {
    Navigator.pushNamedAndRemoveUntil(context, AppConst.homeScreen, (route) => false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('User Information'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            children: [
              finalFileImage == null
                  ? Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/images/user.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showBottomSheet();
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(
                            File(finalFileImage!.path),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showBottomSheet();
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

              SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: saveUserDataToFireStore,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
