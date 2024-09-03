import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.example.app/src/features/core/models/createModel_Model.dart';
import 'package:get/get.dart';

class ModelRepository extends GetxController {
  static ModelRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createModel(CreatemodelModel model) async {
    await _db.collection("Models").add(model.toJson());
  }

  Future<List<CreatemodelModel>> allModels() async {
    final snapshot = await _db.collection("Models").get();
    final modelsData = snapshot.docs.map((e) => CreatemodelModel.fromSnapshot(e)).toList();
    return modelsData;
  }

  Future<void> addUserToFavorites(String modelId, String userId) async {
    final modelRef = _db.collection('Models').doc(modelId);
    await modelRef.update({
      'userFavorites': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> removeUserFromFavorites(String nomeModello, String userId) async {
    final modelRef = _db.collection('Models').doc(nomeModello);
    await modelRef.update({
      'userFavorites': FieldValue.arrayRemove([userId])
    });
  }
}