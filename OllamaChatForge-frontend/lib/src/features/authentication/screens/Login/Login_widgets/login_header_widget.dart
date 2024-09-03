import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(textLoginImage), height: size.height * 0.25,),
        Text(textLoginTitle, style: Theme.of(context).textTheme.headlineLarge),
        Text(textLoginSubTitle, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}