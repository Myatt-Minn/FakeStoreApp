import 'package:flutter/material.dart';

class UsersModel with ChangeNotifier {
  int? id;
  String? email;
  String? password;
  String? name;
  String? role;
  String? avatar;

  UsersModel({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.avatar,
  });

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    role = json['role'];
    avatar = json['avatar'];
  }
  static List<UsersModel> usersfromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return UsersModel.fromJson(data);
    }).toList();
  }
}
