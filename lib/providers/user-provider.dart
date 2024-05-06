import 'package:emigo/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
  );
  UserModel get user => _user;
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}