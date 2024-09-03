import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(textResetOkay),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final size = MediaQuery.of(context).size;
    final isDarkMode = brightness == Brightness.dark;
    final inputBorderColor = isDarkMode ? Colors.grey : Colors.white;
    final textColor = isDarkMode ? Colors.grey : Colors.white;
    final iconColor = isDarkMode ? Colors.grey : Colors.white;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? textSecondaryColor : textPrimaryColor,
        appBar: AppBar(
          backgroundColor: isDarkMode ? textSecondaryColor : textPrimaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(LineAwesomeIcons.angle_left, color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(textDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    textForgotPassword,
                    height: size.height * 0.33,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  textForgoTPassword,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  textForgotInfo,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: iconColor),
                    labelText: textEmail,
                    labelStyle: TextStyle(color: textColor),
                    hintText: textEnterEmail,
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
                    fillColor: isDarkMode ? Colors.black12 : Colors.grey[200],
                    filled: true,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: passwordReset,
                    child: Text(textResetPassword),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
