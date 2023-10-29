import 'package:flutter/material.dart';
import 'package:shop_app/models/user_model.dart';

class UserProvider extends ChangeNotifier{
  User _user = new User(
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      type: '',
      token: '');

  // lay user
  User get user => _user;

  //dat lai gia tri user
  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }
}
