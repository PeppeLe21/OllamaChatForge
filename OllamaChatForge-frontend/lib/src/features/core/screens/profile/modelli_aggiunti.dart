import 'dart:convert';

import 'package:com.example.app/src/features/authentication/controllers/user_controller.dart';
import 'package:com.example.app/src/features/core/controllers/createModel_controller.dart';
import 'package:com.example.app/src/features/core/models/createModel_Model.dart';
import 'package:com.example.app/src/features/core/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../manager/api_util.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';

class PersonalModels extends StatefulWidget {
  const PersonalModels({Key? key}) : super(key: key);

  @override
  _PersonalModelsState createState() => _PersonalModelsState();
}

class _PersonalModelsState extends State<PersonalModels> {
  late Future<List<CreatemodelModel>> _modelsFuture;

  @override
  void initState() {
    super.initState();
    _loadModels();
  }

  void _loadModels() {
    String creatorId = AuthenticationRepository.instance.authUser!.uid;
    _modelsFuture = Get.find<CreateModelController>().getModelsByCreatorId(creatorId);
  }

  Future<void> _deleteModel(BuildContext context, String modelName) async {
    bool isSuccess = false;
    String message = 'Failed to delete model. Please try again.';

    try {
      final response = await ApiUtil.postRequest('/delete', {'name_model': modelName});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        isSuccess = true;
        message = responseData['Message'];
        await CreateModelController.instance.deleteModelByName(modelName);
        print(modelName);
      }
    } catch (e) {
      message = 'Error: $e';
    }

    if (isSuccess) {
      setState(() {
        _loadModels();
      });
    }

    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  void _showDeleteDialog(BuildContext context, String modelName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Sei sicuro di voler eliminare il modello ?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteModel(context, modelName);
              },
            ),
          ],
        );
      },
    );
  }

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
        title: Text("Modelli aggiunti"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(textDefaultSize),
          child: FutureBuilder<List<CreatemodelModel>>(
            future: _modelsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final model = snapshot.data![index];
                      return Column(
                        children: [
                          ListTile(
                            iconColor: textPrimaryColor,
                            leading: CombinedIcon(),
                            title: Text("Nome: ${model.nome}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Modello: ${model.from}"),
                                Text("Descrizione: ${model.description}"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteDialog(context, model.nome),
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
      ),
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
            Icons.add_circle_outlined,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ],
    );
  }
}
