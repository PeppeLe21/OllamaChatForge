import 'package:com.example.app/src/features/authentication/controllers/splash_screen_controller.dart';
import 'package:com.example.app/src/features/authentication/screens/Welcome/welcome_screen.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:com.example.app/src/repository/model_repository/model_repository.dart';
import 'package:com.example.app/src/features/core/controllers/createModel_controller.dart';
import 'package:com.example.app/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(AuthenticationRepository());
    Get.put(ModelRepository());
    Get.put(CreateModelController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}
