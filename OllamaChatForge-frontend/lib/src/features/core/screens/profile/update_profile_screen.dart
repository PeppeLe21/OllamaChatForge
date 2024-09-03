import 'package:com.example.app/src/features/authentication/controllers/user_controller.dart';
import 'package:com.example.app/src/features/authentication/models/user_model.dart';
import 'package:com.example.app/src/features/core/controllers/profilo_controller.dart';
import 'package:com.example.app/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../utils/theme/widget_themes/text_circular_image.dart';
import '../../../authentication/screens/Welcome/welcome_screen.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerProfilo = Get.put(ProfiloController());
    final controllerUser = Get.put(UserController());

    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isdarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
      appBar: AppBar(
        backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left, color: textPrimaryColor),
        ),
        title: Text("Modifica profilo"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(textDefaultSize),
          child: FutureBuilder(
            future: controllerProfilo.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;

                  if (controllerUser.user.value.id == null) {
                    controllerUser.user.value = user;
                  }

                  final email = TextEditingController(text: user.email);
                  final userName = TextEditingController(text: user.userName);

                  return Column(
                    children: [
                      Stack(
                        children: [
                          Obx(() {
                            final networkImage = controllerUser.user.value.profilePicture;
                            final image = networkImage.isNotEmpty ? networkImage : textProfiloImage;
                            return TCircularImage(
                              image: image,
                              width: 300,
                              height: 300,
                              isNetworkImage: networkImage.isNotEmpty,
                            );
                          }),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () async {
                                await controllerUser.uploadUserProfilePicture();
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: textPrimaryColor,
                                ),
                                child: const Icon(
                                  LineAwesomeIcons.camera,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: userName,
                              decoration: const InputDecoration(
                                label: Text(textUsername),
                                prefixIcon: Icon(LineAwesomeIcons.user),
                              ),
                            ),
                            const SizedBox(height: textFormHeight - 20),
                            TextFormField(
                              controller: email,
                              enabled: false,
                              decoration: const InputDecoration(
                                label: Text(textEmail),
                                prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                              ),
                            ),
                            const SizedBox(height: textFormHeight),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final userData = UserModel(
                                    id: user.id,
                                    email: email.text.trim(),
                                    password: user.password,
                                    userName: userName.text.trim(),
                                    profilePicture: controllerUser.user.value.profilePicture,
                                  );

                                  await controllerProfilo.updateRecord(userData);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: textPrimaryColor,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  "Modifica profilo",
                                  style: TextStyle(color: textDarkColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: textFormHeight),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool? confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Conferma eliminazione"),
                                        content: const Text("Sei sicuro di voler eliminare l'account?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text("Si"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    await controllerUser.deleteUserAccount();
                                    Get.offAll(() => const WelcomeScreen());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                                  elevation: 0,
                                  foregroundColor: Colors.red,
                                  shape: const StadiumBorder(),
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                ),
                                child: const Text("Elimina Account"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Qualcosa è andato storto"));
                }
              } else {
                return const Center(child: CircularProgressIndicator(color: textPrimaryColor));
              }
            },
          ),
        ),
      ),
    );
  }
}
