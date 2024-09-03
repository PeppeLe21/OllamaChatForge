import 'package:com.example.app/src/features/authentication/controllers/user_controller.dart';
import 'package:com.example.app/src/features/authentication/models/user_model.dart';
import 'package:com.example.app/src/features/core/controllers/profilo_controller.dart';
import 'package:com.example.app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../utils/theme/widget_themes/text_circular_image.dart';
import '../../controllers/createModel_controller.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart'; // Import AuthenticationRepository

class SelectModel extends StatefulWidget {
  const SelectModel({Key? key}) : super(key: key);

  @override
  _SelectModelState createState() => _SelectModelState();
}

class _SelectModelState extends State<SelectModel> {
  final controller = Get.put(CreateModelController());
  final String userId = AuthenticationRepository.instance.authUser!.uid;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isdarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
      appBar: AppBar(
        backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
        leading: IconButton(
          onPressed: () => Get.to(() => const Dashboard()),
          icon: const Icon(LineAwesomeIcons.angle_left, color: textPrimaryColor),
        ),
        title: Text("Modelli disponibili"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                textDonnaSchermate,
                height: 200,
              ),
            ),
            const Text(
              'Aggiungi i modelli che preferisci ai preferiti per poterli utilizzare nella home',
              textAlign: TextAlign.center,
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: controller.getPublicModels(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final model = snapshot.data![index];
                          final isFavorite = model.userFavorites.contains(userId);

                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(LineAwesomeIcons.robot, color: textPrimaryColor, size: 40.0),
                                title: Text("Nome: ${model.nome}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Modello: ${model.from}"),
                                    Text("Descrizione: ${model.description}"),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FavoriteButton(
                                      isFavorite: isFavorite,
                                      onFavoriteChanged: (newValue) async {
                                        if (newValue) {
                                          await controller.addUserToFavorites(model.nome, userId);
                                        } else {
                                          await controller.removeUserFromFavorites(model.nome, userId);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
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
          ],
        ),
      ),
    );
  }

}

class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  const FavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onFavoriteChanged,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onFavoriteChanged(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
