import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.example.app/src/features/authentication/models/user_model.dart';
import 'package:com.example.app/src/repository/authentication_repository/authentication_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUserRepo(UserModel user) async {
    await _db.collection("Users").add(user.toJson())
        .whenComplete(
          () => Get.snackbar("Operazione confermata", "Il tuo account è stato creato.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green),
    ).catchError((error, stackTrace) {
      Get.snackbar("Errore", "Qualcosa è andato storto. Ritenta",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").
    doc(user.id).
    update(user.toJson());
  }

  Future<UserModel> fetchUserDetails() async {
    final documentSnapshot = await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
    return UserModel.fromSnapshot(documentSnapshot);
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null) {
      print("Errore: ID utente non trovato");
      return;
    }

    try {
      await _db.collection("Users").doc(userId).update(json);
      print("Documento aggiornato con successo per l'utente $userId");
    } catch (e) {
      print("Errore durante l'aggiornamento del documento: $e");
    }
  }

  Future<String> uploadImage(String path, XFile image) async {
    final ref = FirebaseStorage.instance.ref(path).child(image.name);
    await ref.putFile(File(image.path));
    final url = await ref.getDownloadURL();
    return url;
  }

  Future<void> deleteUserByEmail(String email) async {
    try {
      final querySnapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await _db.collection("Users").doc(doc.id).delete();
        }
        print("Utente eliminato con successo dal database Firestore");
      } else {
        print("Errore: Utente non trovato nel database Firestore");
      }
    } catch (e) {
      print("Errore durante l'eliminazione dell'utente: $e");
    }
  }
}
