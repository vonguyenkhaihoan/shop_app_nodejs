import 'package:shop_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = new User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    phone: '',
    gender: '',
    type: '',
    token: '',
    cart: [],
  );

  // lay user
  User get user => _user;

  //dat lai gia tri user
  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  // dat lai mo hinh nguoi dung
  void setUserFromModel(User user) {
    // Gán đối tượng người dùng mới cho trường riêng
    _user = user;
    // Thông báo cho bất kỳ trình nghe nào về thay đổi
    notifyListeners();
  }
}
