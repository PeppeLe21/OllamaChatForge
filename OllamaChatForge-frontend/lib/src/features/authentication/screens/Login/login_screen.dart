import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'Login_widgets/login_footer_widget.dart';
import 'Login_widgets/login_form_widget.dart';
import 'Login_widgets/login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final size = MediaQuery.of(context).size;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeaderWidget(size: size),
                const LoginForm(),
                const LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
