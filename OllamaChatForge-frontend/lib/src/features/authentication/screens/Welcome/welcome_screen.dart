import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:com.example.app/src/features/authentication/screens/Login/login_screen.dart';

import '../../../../../firebase_options.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../../repository/model_repository/model_repository.dart';
import '../../../core/controllers/createModel_controller.dart';
import '../../controllers/splash_screen_controller.dart';
import '../Registrazione/registrazione_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isdarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
      body: Container(
        padding: EdgeInsets.all(textDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.1),
            Image(image: AssetImage(textChatBotImage), height: height * 0.5),
            SizedBox(height: 20),
            Text(
              textWelcomeTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isdarkMode ? textPrimaryColor : textWhiteColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              textWelcomeSubTitle,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    child: Text(
                      textLogin.toUpperCase(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const RegistrazioneScreen()),
                    child: Text(
                      textRegistrati.toUpperCase(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


