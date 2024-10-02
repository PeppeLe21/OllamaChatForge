import 'package:com.example.app/src/features/core/models/createModel_Model.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../manager/api_util.dart';
import '../../controllers/createModel_controller.dart';
import '../dashboard/dashboard.dart';
import '../profile/profile_screen.dart';
import '../profile/update_profile_screen.dart';

class CreateModelScreen extends StatelessWidget {
  const CreateModelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isdarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.angle_left, color: textPrimaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(textCreaModello),
        backgroundColor: isdarkMode ? textSecondaryColor : textPrimaryColor,
        foregroundColor: isdarkMode ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FormHeaderWidget(
                image: textCreateModelImage,
                description: textCreaInfo,
                imageHeight: 190.0,
              ),
              const CreateModelFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateModelFormWidget extends StatefulWidget {
  const CreateModelFormWidget({super.key});

  @override
  _CreateModelFormWidgetState createState() => _CreateModelFormWidgetState();
}

class _CreateModelFormWidgetState extends State<CreateModelFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(CreateModelController());
  List<CreatemodelModel> _publicModels = [];
  CreatemodelModel? _selectedModel;

  @override
  void initState() {
    super.initState();
    _fetchPublicModels();
  }

  Future<void> _fetchPublicModels() async {
    List<CreatemodelModel> models = await controller.getPublicModels();
    setState(() {
      _publicModels = models;
    });
  }

  void _showInfoDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Info',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: TextStyle(color: textPrimaryColor),
          ),
          backgroundColor: textSecondaryColor,
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration getInputDecoration({
    required String label,
    required Icon prefixIcon,
    required String infoMessage,
    required BuildContext context,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon.icon),
      suffixIcon: IconButton(
        icon: Icon(Icons.info_outline),
        onPressed: () => _showInfoDialog(context, infoMessage),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }

  void _resetFormFields() {
    controller.nome.clear();
    controller.from.clear();
    controller.parameter.clear();
    controller.system.clear();
    controller.descrizione.clear();
    controller.isPublic.value = false;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String nome = controller.nome.text;
      final String from = _selectedModel?.nome ?? '';
      final String parameter = controller.parameter.text;
      final String system = controller.system.text;
      final String descrizione = controller.descrizione.text;
      final String creatorId = AuthenticationRepository.instance.authUser!.uid;
      final bool isPublic = controller.isPublic.value;

      try {
        final response = await ApiUtil.postRequest('/create', {
          'name_model': nome,
          'from_model': from,
          'parameter': parameter,
          'system': system,
          'description': descrizione,
          'public': isPublic,
        });

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          final model = CreatemodelModel(
            nome: controller.nome.text.trim(),
            from: from,
            parameter: controller.parameter.text.trim(),
            system: controller.system.text.trim(),
            description: controller.descrizione.text.trim(),
            creatorId: creatorId,
            isPublic: isPublic,
          );
          CreateModelController.instance.createModel(model);

          Get.snackbar(
            'Modello creato con successo',
            'Aggiungilo ai preferiti per poterlo utilizzare',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: textSecondaryColor,
            colorText: textPrimaryColor,
          );

          _resetFormFields();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create model. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.nome,
              decoration: getInputDecoration(
                label: 'Nome',
                prefixIcon: Icon(Icons.person_outline),
                infoMessage: textInfoNome,
                context: context,
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<CreatemodelModel>(
              value: _selectedModel,
              decoration: getInputDecoration(
                label: 'From',
                prefixIcon: Icon(Icons.location_on_outlined),
                infoMessage: textInfoFrom,
                context: context,
              ),
              items: _publicModels.map((model) {
                return DropdownMenuItem<CreatemodelModel>(
                  value: model,
                  child: Text(model.nome),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: controller.parameter,
              decoration: getInputDecoration(
                label: 'Parameter',
                prefixIcon: Icon(Icons.settings_outlined),
                infoMessage: textInfoParameter,
                context: context,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: controller.system,
              decoration: getInputDecoration(
                label: 'System',
                prefixIcon: Icon(Icons.computer_outlined),
                infoMessage: textInfoSystem,
                context: context,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: controller.descrizione,
              decoration: getInputDecoration(
                label: 'Descrizione',
                prefixIcon: Icon(Icons.description_outlined),
                infoMessage: textInfoDescrizione,
                context: context,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            Obx(() => CheckboxListTile(
              title: Text("Modello pubblico"),
              value: controller.isPublic.value,
              onChanged: (newValue) {
                controller.isPublic.value = newValue ?? false;
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: textPrimaryColor,
            )),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text('SALVA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormHeaderWidget extends StatelessWidget {
  final String image;
  final String description;
  final double imageHeight;

  const FormHeaderWidget({
    required this.image,
    required this.description,
    this.imageHeight = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          height: imageHeight,
        ),
        const SizedBox(height: 16.0),
        Text(
          description,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
