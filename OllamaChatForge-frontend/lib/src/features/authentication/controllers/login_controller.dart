import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:com.example.app/src/features/authentication/controllers/user_controller.dart';
import 'package:com.example.app/src/manager/network_manager.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  final userController = Get.put(UserController());

  void loggaUser(String email, String password) {
    AuthenticationRepository.
    instance.
    loginWithEmailAndPassword(email, password);
  }

  Future<void> googleSignIn() async {
    final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

    await userController.saveUserRecord(userCredentials);
  }


}