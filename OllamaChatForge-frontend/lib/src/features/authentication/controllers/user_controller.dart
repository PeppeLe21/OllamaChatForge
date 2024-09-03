import 'dart:ffi';
import 'package:com.example.app/src/features/authentication/models/user_model.dart';
import 'package:com.example.app/src/repository/user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  Rx<UserModel> user = UserModel.empty().obs;

  final imageUploading = false.obs;

  Future<void> fetchUserRecord() async {
    final user = await userRepository.fetchUserDetails();
    this.user(user);
  }

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    await fetchUserRecord();
    final username = UserModel.generateUsername(userCredentials?.user!.email ?? '');

    final user = UserModel(
      email: userCredentials?.
      user!.email ?? '',
      password: '',
      userName: username,
      profilePicture: userCredentials?.user!.photoURL ?? '',
    );

    await userRepository.updateUserRecord(user);
  }

  Future<void> uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        final imageUrl = await userRepository.uploadImage('Users/Images/Profile/', image);
        if (imageUrl.isNotEmpty) {
          Map<String, dynamic> json = {'profilePicture': imageUrl};
          await userRepository.updateSingleField(json);

          user.value.profilePicture = imageUrl;
          user.refresh();
        }
      }
    } catch (e) {
    }
  }

  Future<void> deleteUserAccount() async {
    final userEmail = AuthenticationRepository.instance.authUser?.email;
    if (userEmail == null) {
      return;
    }

    try {
      await userRepository.deleteUserByEmail(userEmail);
      await AuthenticationRepository.instance.authUser?.delete();
    } catch (e) {
    }
  }
}
