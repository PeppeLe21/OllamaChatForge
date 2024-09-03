import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:com.example.app/src/features/authentication/screens/Registrazione/Registrazione_widgets/registrazione_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../controllers/login_controller.dart';
import '../Login/login_screen.dart';

class RegistrazioneScreen extends StatelessWidget {
  const RegistrazioneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isdarkMode = brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
        appBar: AppBar(
          backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.angle_left, color: isdarkMode ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(textDefaultSize),
            child: Column(
              children: [
                const FormHeaderWidget(
                  image: textRegistrazioneImage,
                  description: textRegistrazioneSubTitle,
                ),
                const RegistrazioneFormWidget(),
                Column(
                  children: [
                    const Text("OPPURE"),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => controller.googleSignIn(),
                        icon: Image(
                          image: AssetImage(textGoogleLogoImage),
                          width: 20.0,
                        ),
                        label: Text(textSignInWithGoogle.toUpperCase()),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const LoginScreen()),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: textAlreadyHaveAnAccount,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: textLogin.toUpperCase(),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
