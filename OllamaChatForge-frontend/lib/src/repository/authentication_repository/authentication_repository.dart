import 'package:com.example.app/src/common_widgets/form/form_header_widget.dart';
import 'package:com.example.app/src/features/authentication/screens/Welcome/welcome_screen.dart';
import 'package:com.example.app/src/features/core/screens/dashboard/dashboard.dart';
import 'package:com.example.app/src/repository/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:flutter/material.dart';
import 'package:com.example.app/src/constants/colors.dart';
import 'package:com.example.app/src/constants/image_string.dart';
import 'package:com.example.app/src/constants/text_strings.dart';
import 'package:com.example.app/src/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/authentication/models/user_model.dart';
import '../user_repository/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  final userRepo = Get.put(UserRepository());

  User? get authUser => _auth.currentUser;

  final _db = FirebaseFirestore.instance;

  @override
  void onReady() {

    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomeScreen()) : Get.offAll(() => const Dashboard());
  }

  Future<void> createUserWithEmailAndPassword(UserModel user) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      await userRepo.createUserRepo(user);
      firebaseUser.value != null ? Get.offAll(() => const Dashboard()) : Get.to(() => WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      Get.snackbar('Errore di Registrazione', ex.message,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      Get.snackbar('Errore di Registrazione', ex.message,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final userDoc = await _db.collection('Users').where('Email', isEqualTo: email).get();

      if (userDoc.docs.isNotEmpty) {
        final fullName = userDoc.docs[0].data()['FullName'];

        Get.snackbar(
          'Accesso effettuato',
          'Bentornato $fullName',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );

        Get.offAll(() => const Dashboard());
      } else {
        throw Exception('User not found');
      }

    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      Get.snackbar('Errore di Accesso', ex.message,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      Get.snackbar('Errore di Accesso', ex.message,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      throw ex;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}

