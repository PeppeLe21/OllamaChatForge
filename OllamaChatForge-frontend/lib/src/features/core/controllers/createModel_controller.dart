import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.example.app/src/features/core/models/createModel_Model.dart';
import 'package:com.example.app/src/repository/model_repository/model_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreateModelController extends GetxController {
  static CreateModelController get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nome = TextEditingController();
  final from = TextEditingController();
  final parameter = TextEditingController();
  final system = TextEditingController();
  final descrizione = TextEditingController();
  final isPublic = false.obs; // Aggiunto campo osservabile

  Future<void> createModel(CreatemodelModel model) async {
    await ModelRepository.instance.createModel(model);
  }

  Future<List<CreatemodelModel>> getAllModels() async {
    return await ModelRepository.instance.allModels();
  }

  Future<List<CreatemodelModel>> getPublicModels() async {
    final querySnapshot = await _firestore.collection('Models').where('public', isEqualTo: true).get();

    return querySnapshot.docs.map((doc) => CreatemodelModel.fromSnapshot(doc)).toList();
  }

  Future<List<CreatemodelModel>> getModelsByCreatorId(String creatorId) async {
    final querySnapshot = await _firestore
        .collection('Models')
        .where('creatorId', isEqualTo: creatorId)
        .get();

    return querySnapshot.docs.map((doc) => CreatemodelModel.fromSnapshot(doc)).toList();
  }

  Future<void> addUserToFavorites(String modelName, String userId) async {
    final querySnapshot = await _firestore.collection('Models').where('name_model', isEqualTo: modelName).get();
    final docId = querySnapshot.docs.first.id;
    final docRef = _firestore.collection('Models').doc(docId);
    await docRef.update({
      'userFavorites': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> removeUserFromFavorites(String modelName, String userId) async {
    final querySnapshot = await _firestore.collection('Models').where('name_model', isEqualTo: modelName).get();
    final docId = querySnapshot.docs.first.id;
    final docRef = _firestore.collection('Models').doc(docId);
    await docRef.update({
      'userFavorites': FieldValue.arrayRemove([userId])
    });
  }

  Future<List<CreatemodelModel>> getModelsByUserFavorites(String userId) async {
    final querySnapshot = await _firestore
        .collection('Models')
        .where('userFavorites', arrayContains: userId)
        .get();

    return querySnapshot.docs.map((doc) => CreatemodelModel.fromSnapshot(doc)).toList();
  }

  Future<void> deleteModelByName(String modelName) async {
    final querySnapshot = await _firestore.collection('Models').where('name_model', isEqualTo: modelName).get();
    for (var doc in querySnapshot.docs) {
      await _firestore.collection('Models').doc(doc.id).delete();
    }
  }
}