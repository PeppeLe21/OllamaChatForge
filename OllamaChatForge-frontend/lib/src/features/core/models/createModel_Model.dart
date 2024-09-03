import 'package:cloud_firestore/cloud_firestore.dart';

class CreatemodelModel {
  final String nome;
  final String from;
  final String parameter;
  final String system;
  final String description;
  final String creatorId;
  final bool isPublic;
  final List<String> userFavorites;

  CreatemodelModel({
    required this.nome,
    required this.from,
    required this.parameter,
    required this.system,
    required this.description,
    required this.creatorId,
    this.isPublic = false,
    this.userFavorites = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name_model': nome,
      'from_model': from,
      'parameter': parameter,
      'system': system,
      'description': description,
      'creatorId': creatorId,
      'public': isPublic,
      'userFavorites': userFavorites,
    };
  }

  factory CreatemodelModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CreatemodelModel(
      nome: data["name_model"],
      from: data["from_model"],
      parameter: data["parameter"],
      system: data["system"],
      description: data["description"],
      creatorId: data["creatorId"],
      isPublic: data["public"] ?? false,
      userFavorites: List<String>.from(data["userFavorites"] ?? []),
    );
  }
}
