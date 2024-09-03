import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String userName;
  final String email;
  final String password;
  String profilePicture;

  static String generateUsername(String email) {
    int atIndex = email.indexOf('@');

    if (atIndex == -1) {
      return email;
    }

    return email.substring(0, atIndex);
  }

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.userName,
    required this.profilePicture,
  });

  static UserModel empty() => UserModel(email: '', password: '', userName: '', profilePicture: '');

  toJson(){
    return {
      "FullName": userName,
      "Email": email,
      "ProfilePicture": profilePicture,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      password: '',
      userName: data["FullName"],
      profilePicture: data["ProfilePicture"],
    );
  }
}