import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:com.example.app/src/features/authentication/models/user_model.dart';
import 'package:com.example.app/src/features/authentication/screens/Registrazione/Registrazione_widgets/registrazione_form_widget.dart';
import 'package:com.example.app/src/features/core/controllers/profilo_controller.dart';
import 'package:com.example.app/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:com.example.app/src/features/core/screens/profile/modelli_aggiunti.dart';
import 'package:com.example.app/src/features/core/screens/profile/widgets/profilo_menu.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../repository/authentication_repository/authentication_repository.dart';
import '../../../authentication/controllers/user_controller.dart';
import '../dashboard/dashboard.dart';
import 'modelli_preferiti.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isdarkMode = brightness == Brightness.dark;
    final controller = Get.put(ProfiloController());
    final userController = Get.put(UserController());

    return Scaffold(
      backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
      appBar: AppBar(
        backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
        leading: IconButton(
          onPressed: () => Get.to(() => const Dashboard()),
          icon: const Icon(LineAwesomeIcons.angle_left, color: textPrimaryColor),
        ),
        title: Text("Profilo"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(textDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: textPrimaryColor));
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: userData.profilePicture.isNotEmpty
                                  ? Image.network(
                                userData.profilePicture,
                                fit: BoxFit.cover,
                              )
                                  : const Image(image: AssetImage(textProfiloImage)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(userData.userName, style: Theme.of(context).textTheme.headlineLarge),
                      Text(userData.email, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => const UpdateProfileScreen()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: textPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Modifica profilo", style: TextStyle(color: textDarkColor)),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfiloMenuWidget(title: "Modelli preferiti", icon: LineAwesomeIcons.heart, onPress: () {Get.to(() => const UserFavoritesModels());}),
                      ProfiloMenuWidget(title: "Modelli aggiunti", icon: LineAwesomeIcons.list, onPress: () {Get.to(() => const PersonalModels());}),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      ProfiloMenuWidget(
                        title: "Logout",
                        icon: LineAwesomeIcons.alternate_sign_out,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          AuthenticationRepository.instance.logout();
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Qualcosa è andato storto"));
                }
              } else {
                return const Center(child: Text("Qualcosa è andato storto"));
              }
            },
          ),
        ),
      ),
    );
  }
}
