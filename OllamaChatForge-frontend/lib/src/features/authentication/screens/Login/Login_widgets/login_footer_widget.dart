import 'package:com.example.app/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import '../../../../../services/auth_service.dart';
import '../../Registrazione/registrazione_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OPPURE"),
        const SizedBox(height: textFormHeight - 20,),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
              icon: const Image(image: AssetImage(textGoogleLogoImage), width: 20.0,),
              onPressed: () => controller.googleSignIn(),
              label: Text(textSignInWithGoogle)),
        ),
        const SizedBox(
          height: textFormHeight - 20 ,
        ),
        TextButton(
            onPressed: () => Get.to(() => const RegistrazioneScreen()),
            child: Text.rich(
                TextSpan(
                    text: textDontHaveAnAccount,
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: const[
                      TextSpan(
                        text: textSignUp,
                        style: TextStyle(color: Colors.blue),
                      )
                    ]
                )
            ))
      ],
    );
  }
}