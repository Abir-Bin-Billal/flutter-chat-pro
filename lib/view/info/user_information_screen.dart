import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/providers/image_picker_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';

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

    // Then crop the selected image
    cropImage(pickedFile.path);
  }
}




Future<void> cropImage(String imagePath) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Crop Image',
      ),
    ],
  );

  if (croppedFile != null) {
    setState(() {
      finalFileImage = File(croppedFile.path);
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
            ],
          ),
        ),
      ),
    );
  }
}
