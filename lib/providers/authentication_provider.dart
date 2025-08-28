import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_pro/models/user_model.dart';
import 'package:flutter_chat_pro/utils/app_const.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccessful = false;
  String? _phoneNumber;
  String? _uid;
  UserModel? userModel;
  String? _verificationId;

  bool get isLoading => _isLoading;
  bool get isSuccessful => _isSuccessful;
  String? get uid => _uid;
  String? get phoneNumber => _phoneNumber;
  String? get verificationId => _verificationId;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) async {
            _uid = value.user!.uid;
            _phoneNumber = value.user!.phoneNumber;
            _isSuccessful = true;
            _isLoading = false;
            notifyListeners();
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          _isLoading = false;
          notifyListeners(); // 👈 add this
          Fluttertoast.showToast(msg: e.message ?? "Verification failed");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _phoneNumber = phoneNumber;
          _isLoading = false;
          notifyListeners();

          Navigator.pushNamed(
            context,
            AppConst.otpScreen,
            arguments: <String, String>{
              'verificationId': verificationId,
              'phoneNumber': phoneNumber,
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _isLoading = false;
          notifyListeners(); // 👈 add this
          print("Navigate to OTP screen");
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners(); // 👈 add this
      Fluttertoast.showToast(msg: "Invalid phone number format");
    }
  }

  Future<void> verifyOTP({
    required String verificationId,
    required String otp,
    required BuildContext context,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
          _uid = value.user!.uid;
          _phoneNumber = value.user!.phoneNumber;
          _isSuccessful = true;
          _isLoading = false;
          onSuccess();
          notifyListeners();
        })
        .catchError((error) {
          _isLoading = false;
          Fluttertoast.showToast(msg: error.toString());
        });
  }

  Future<bool> checkUserExist() async {
    DocumentSnapshot userDoc = await firestore
        .collection("users")
        .doc(_uid)
        .get();
    if (userDoc.exists) {
      userModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      return true;
    }
    return false;
  }

  Future<bool> checkAuthenticationState() async {
    bool isSignedIn = false;
    await Future.delayed(const Duration(seconds: 2));
    if (auth.currentUser != null) {
      _uid = auth.currentUser!.uid;
      isSignedIn = true;
      await getUserDataFromFirestore();
      await saveUserDataToSecureStorage();
    } else {
      isSignedIn = false;
    }
    return isSignedIn;
  }

  Future<void> getUserDataFromFirestore() async {
    DocumentSnapshot userDoc = await firestore
        .collection("users")
        .doc(_uid)
        .get();
    if (userDoc.exists) {
      userModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      notifyListeners();
    }
  }

  Future<void> saveUserDataToSecureStorage() async {
    await FlutterSecureStorage().write(
      key: "userModel",
      value: jsonEncode(userModel!.toJson()),
    );
  }

  Future<void> getUserDataFromSecureStorage() async {
    String? userData =
        await FlutterSecureStorage().read(key: "userModel") ?? "";
    if (userData != "") {
      userModel = UserModel.fromJson(jsonDecode(userData));
      _uid = userModel!.uid;
      notifyListeners();
    }
  }

  Future<void> saveUserDataToFireStore({
    required UserModel userModel,
    required File? fileImage,
    required Function onSuccess,
    required Function onError,
  }) async {
    if (fileImage == null) {
      Fluttertoast.showToast(msg: "Please select an image first!");
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      // Upload to Firebase Storage and get download URL
      String imageUrl = await storeFileFirestore(file: fileImage, uid: _uid!);

      print("Image uploaded successfully: $imageUrl");

      // Save download URL in Firestore
      userModel.image = imageUrl;
      userModel.uid = _uid!;
      userModel.lastSeen = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();

      await firestore
          .collection(AppConst.users)
          .doc(userModel.uid)
          .set(userModel.toJson());

      this.userModel = userModel;
      await saveUserDataToSecureStorage();

      _isLoading = false;
      onSuccess();
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      onError(e.message ?? "Something went wrong");
    }
  }

  Future<String> storeFileFirestore({
    required File file,
    required String uid,
  }) async {
    try {
      // Convert file to Base64
      Uint8List imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Save Base64 in Firestore
      await firestore.collection("userImages").doc(uid).set({
        "image": base64Image,
        "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
      });

      return base64Image;
    } catch (e) {
      print("Upload to Firestore failed: $e");
      rethrow;
    }
  }

  Future<void> sendFriendRequest({required String friendID}) async {
    try {
      await firestore.collection(AppConst.users).doc(friendID).update({
        AppConst.friendRequestsUIDS: FieldValue.arrayUnion([_uid]),
      });
      await firestore.collection(AppConst.users).doc(_uid).update({
        AppConst.sentFriendRequestsUIDS: FieldValue.arrayUnion([friendID]),
      });
    } on FirebaseException catch (e) {
      print("Error sending friend request: $e");
    }
  }

  Stream<DocumentSnapshot> getUserStream({required String userID}) {
    return firestore.collection(AppConst.users).doc(userID).snapshots();
  }

  Stream<QuerySnapshot> getAllUserStream({required String userID}) {
    return firestore
        .collection(AppConst.users)
        .where(AppConst.uid, isNotEqualTo: userID)
        .snapshots();
  }

  Future logOut() async {
    await auth.signOut();
    FlutterSecureStorage().deleteAll();
    userModel = null;
    _uid = null;
    notifyListeners();
  }
}
