import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:com.example.app/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import '../../../controllers/registrazione_controller.dart';

class RegistrazioneFormWidget extends StatefulWidget {
  const RegistrazioneFormWidget({super.key});

  @override
  _RegistrazioneFormWidgetState createState() => _RegistrazioneFormWidgetState();
}

class _RegistrazioneFormWidgetState extends State<RegistrazioneFormWidget> {
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

    InputDecoration getInputDecoration({required String label, required Icon prefixIcon, IconButton? suffixIcon}) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        prefixIcon: Icon(prefixIcon.icon, color: iconColor),
        hintText: label,
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
        suffixIcon: suffixIcon,
      );
    }

    final controller = Get.put(RegistrazioneController());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: textFormHeight - 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.fullName,
              style: TextStyle(color: textColor),
              decoration: getInputDecoration(
                label: textUsername,
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: textFormHeight - 20),
            TextFormField(
              controller: controller.email,
              style: TextStyle(color: textColor),
              decoration: getInputDecoration(
                label: textEmail,
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: textFormHeight - 20),
            TextFormField(
              controller: controller.password,
              obscureText: _isObscured,
              style: TextStyle(color: textColor),
              decoration: getInputDecoration(
                label: textPassword,
                prefixIcon: Icon(Icons.fingerprint),
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
            const SizedBox(height: textFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = UserModel(
                      email: controller.email.text.trim(),
                      password: controller.password.text.trim(),
                      userName: controller.fullName.text.trim(),
                      profilePicture: textProfiloImage,
                    );
                    RegistrazioneController.instance.createUser(user);
                  }
                },
                child: Text(textRegistrati.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
