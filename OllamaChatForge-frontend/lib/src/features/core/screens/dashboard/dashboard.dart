import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'package:http/http.dart' as http;

import '../../../../manager/api_util.dart';
import '../drawer/create_model.dart';
import '../drawer/infoApp_model.dart';
import '../drawer/select_model.dart';
import '../profile/profile_screen.dart';
import 'package:com.example.app/src/features/authentication/controllers/user_controller.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:com.example.app/src/features/core/controllers/createModel_controller.dart';

class Message {
  final String text;
  final bool isUser;
  final String model;

  Message({required this.text, required this.isUser, required this.model});
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  List<String> _selectedModels = [];
  List<String> _availableModels = [];
  final CreateModelController _modelController = Get.put(CreateModelController());
  final String userId = AuthenticationRepository.instance.authUser!.uid;
  bool _isFirstMessage = true;
  bool _isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteModels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteModels();
  }

  Future<void> _loadFavoriteModels() async {
    try {
      final favoriteModels = await _modelController.getModelsByUserFavorites(userId);
      setState(() {
        _availableModels = favoriteModels.map((model) => model.nome).toList();
      });
    } catch (e) {
      // Handle error
    }
  }

  void _sendMessage(String userMessage) async {
    if (userMessage.isNotEmpty && _selectedModels.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: userMessage, isUser: true, model: 'User'));
        _isFirstMessage = false;
        _isWaitingForResponse = true;
      });

      _controller.clear();

      List<Future<http.Response>> requests = _selectedModels.map((model) {
        return ApiUtil.postRequest('/chat', {
          'model': model,
          'prompt': userMessage,
        });
      }).toList();

      final responses = await Future.wait(requests);

      for (int i = 0; i < responses.length; i++) {
        if (responses[i].statusCode == 200) {
          final data = jsonDecode(responses[i].body);
          final botResponse = data.toString();
          setState(() {
            _messages.add(Message(text: botResponse, isUser: false, model: _selectedModels[i]));
          });
        } else {
          setState(() {
            _messages.add(Message(text: 'Error: ${responses[i].statusCode}', isUser: false, model: 'Error'));
          });
        }
      }

      setState(() {
        _isWaitingForResponse = false;
      });
    }
  }

  Future<void> _selectModels() async {
    final selectedModels = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        List<String> tempSelectedModels = List.from(_selectedModels);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(textChooseModels),
              content: SingleChildScrollView(
                child: ListBody(
                  children: _availableModels.map((model) {
                    return CheckboxListTile(
                      title: Text(model),
                      value: tempSelectedModels.contains(model),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (tempSelectedModels.length < 2) {
                              tempSelectedModels.add(model);
                            }
                          } else {
                            tempSelectedModels.remove(model);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(textAnnulla),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(textOk),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelectedModels);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedModels != null) {
      setState(() {
        _selectedModels = selectedModels;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? textSecondaryColor : textPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.menu, color: textPrimaryColor),
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _selectModels,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: textPrimaryColor),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _selectedModels.isEmpty ? textChooseModels : textModelliSelezionati,
                                style: TextStyle(color: textPrimaryColor),
                              ),
                              Icon(LineAwesomeIcons.angle_down, color: textPrimaryColor),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _selectedModels.map((model) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          model,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20, top: 7),
              child: IconButton(
                onPressed: () => Get.to(() => const ProfileScreen()),
                icon: Icon(LineAwesomeIcons.user, color: textPrimaryColor, size: 32),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: isDarkMode ? textSecondaryColor : textPrimaryColor,
        child: Container(
          width: 250,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.mark_chat_read, color: textPrimaryColor),
                title: Text(textModelliDisponibili),
                onTap: () {
                  Get.to(() => const SelectModel());
                },
              ),
              ListTile(
                leading: Icon(Icons.add_comment_rounded, color: textPrimaryColor),
                title: Text(textCreateModel),
                onTap: () {
                  Get.to(() => const CreateModelScreen());
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: textPrimaryColor),
                title: Text(textInfoApp),
                onTap: () {
                  Get.to(() => InfoPage());
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Align(
                        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message.isUser ? textPrimaryColor : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                              bottomLeft: message.isUser ? Radius.circular(12.0) : Radius.circular(0),
                              bottomRight: message.isUser ? Radius.circular(0) : Radius.circular(12.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!message.isUser)
                                Text(
                                  'Model: ${message.model}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              Text(
                                message.text,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_isFirstMessage)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _buildPredefinedMessageButton("Ciao chi sei?"),
                        _buildPredefinedMessageButton("Cos'è Ollama'?"),
                        _buildPredefinedMessageButton("Quali modelli sono disponibili?"),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    if (!_isWaitingForResponse) ...[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: textScriviMex,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: textPrimaryColor),
                        onPressed: () => _sendMessage(_controller.text),
                      ),
                    ] else ...[
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            textWhiteChatGif,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_isFirstMessage)
            Center(
              child: Image.asset(
                textOllamaLogo,
                width: 50,
                height: 50,
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildPredefinedMessageButton(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: textPrimaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        onPressed: () => _sendMessage(message),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}