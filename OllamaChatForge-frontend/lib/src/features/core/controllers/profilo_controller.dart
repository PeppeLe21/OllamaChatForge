import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:com.example.app/src/features/authentication/models/user_model.dart';
import 'package:com.example.app/src/features/authentication/screens/Registrazione/Registrazione_widgets/registrazione_form_widget.dart';
import 'package:com.example.app/src/features/core/screens/profile/widgets/profilo_menu.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:com.example.app/src/repository/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfiloController extends GetxController {
  static ProfiloController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar(textError, textLogToCont);
    }
  }

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }
}