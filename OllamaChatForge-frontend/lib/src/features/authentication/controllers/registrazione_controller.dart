import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:com.example.app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:com.example.app/src/repository/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class RegistrazioneController extends GetxController {
  static RegistrazioneController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();

  Future<void> createUser(UserModel user) async {
    AuthenticationRepository.
    instance.
    createUserWithEmailAndPassword(user);
  }

}