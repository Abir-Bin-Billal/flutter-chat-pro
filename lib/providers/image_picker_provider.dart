import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {

  Future<File?> pickImage({
    required bool fromCamera,
    required Function(String) onFail
  }) async {
    File? fileImage;
 if(fromCamera){
     try {
      final pickedFile = await ImagePicker().pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedFile != null) {
        fileImage= File(pickedFile.path);
      }else{
        onFail("No image selected");  
      }
    } catch (e) {
      onFail(e.toString());
    }
 }else{
  try{
    final pickedFile = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      fileImage= File(pickedFile.path);
    }else{
      onFail("No image selected");
    }
  } catch (e) {
    onFail(e.toString());
  }
 }
    return fileImage;
  }
  }

