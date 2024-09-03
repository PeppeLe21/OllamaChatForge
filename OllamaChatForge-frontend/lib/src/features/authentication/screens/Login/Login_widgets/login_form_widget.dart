import 'package:com.example.app/src/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';

import '../ForgetPassword_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    final inputBorderColor = isDarkMode ? Colors.grey : Colors.white;
    final textColor = isDarkMode ? Colors.grey : Colors.white;
    final iconColor = isDarkMode ? Colors.grey : Colors.white;
    final controller = Get.put(LoginController());

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: textFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined, color: iconColor),
                labelText: textEmail,
                labelStyle: TextStyle(color: textColor),
                hintText: textEmail,
                hintStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBorderColor),
                ),
              ),
            ),
            const SizedBox(height: textFormHeight - 20),
            TextFormField(
              controller: controller.password,
              obscureText: _isObscured,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.fingerprint, color: iconColor),
                labelText: textPassword,
                labelStyle: TextStyle(color: textColor),
                hintText: textPassword,
                hintStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: inputBorderColor),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: textFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.to(() => const ForgetPasswordScreen());
                },
                child: Text(
                  textForgetPassword,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    LoginController.instance.loggaUser(
                      controller.email.text.trim(),
                      controller.password.text.trim(),
                    );
                  }
                },
                child: Text(textLogin.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
