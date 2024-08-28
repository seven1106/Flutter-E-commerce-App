import 'package:emigo/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    phone: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
    wishlist: []
  );
  UserModel get user => _user;
  void setUser(String user) {
    _user = UserModel.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
