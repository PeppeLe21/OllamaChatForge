import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';

class FormHeaderWidget extends StatelessWidget{
  const FormHeaderWidget({
    Key? key,
    required this.image,
    required this.description,
  }) : super(key: key);

  final String image, description;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(image: AssetImage(image), height: size.height * 0.25),
        Text(description, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}