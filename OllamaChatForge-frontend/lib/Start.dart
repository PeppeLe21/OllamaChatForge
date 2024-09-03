
import 'package:com.example.app/src/features/authentication/screens/Welcome/welcome_screen.dart';
import 'package:com.example.app/src/features/core/controllers/createModel_controller.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:com.example.app/src/repository/model_repository/model_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'firebase_options.dart';

class Start {
  void inizialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then((value) {
      Get.put(AuthenticationRepository());
      Get.put(ModelRepository());
      Get.put(CreateModelController());
      Get.to(const WelcomeScreen());
    });
  }
}