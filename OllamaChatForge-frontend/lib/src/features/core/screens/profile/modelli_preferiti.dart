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
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';

class UserFavoritesModels extends StatefulWidget {
  const UserFavoritesModels({Key? key}) : super(key: key);

  @override
  _UserFavoritesModelsState createState() => _UserFavoritesModelsState();
}

class _UserFavoritesModelsState extends State<UserFavoritesModels> {
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
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left, color: textPrimaryColor),
        ),
        title: Text("Modelli preferiti"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: controller.getModelsByUserFavorites(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final model = snapshot.data![index];
                      final isFavorite = model.userFavorites.contains(userId);

                      return Column(
                        children: [
                          ListTile(
                            leading: CombinedIcon(),
                            title: Text("Nome: ${model.nome}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Modello: ${model.from}"),
                                Text("Descrizione: ${model.description}"),
                              ],
                            ),
                            trailing: FavoriteButton(
                              isFavorite: isFavorite,
                              onFavoriteChanged: (newValue) async {
                                if (newValue) {
                                  await controller.addUserToFavorites(model.nome, userId);
                                } else {
                                  await controller.removeUserFromFavorites(model.nome, userId);
                                }
                                setState(() {});
                              },
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
                  return const Center(child: Text("Non hai ancora aggiunto modelli ai preferiti"));
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

class CombinedIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          LineAwesomeIcons.robot,
          color: textPrimaryColor,
          size: 40.0,
        ),
        Positioned(
          top: 2,
          right: 2,
          child: Icon(
            Icons.favorite,
            color: Colors.redAccent,
            size: 20.0,
          ),
        ),
      ],
    );
  }
}
