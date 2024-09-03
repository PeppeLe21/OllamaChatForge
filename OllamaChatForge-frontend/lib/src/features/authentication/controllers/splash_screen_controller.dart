

import 'package:com.example.app/Start.dart';
import 'package:com.example.app/src/features/authentication/screens/Welcome/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class SplashScreenController extends GetxController{
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async{
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 5000));
    Get.to(const WelcomeScreen());
    //Start().inizialize();
  }
}