import 'dart:convert';

import 'package:shop_app/common/widgets/bottom_bar.dart';
import 'package:shop_app/config/config.dart';
import 'package:shop_app/constains/error_handling.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/home/screen/home_screen.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //ham dang ky nguoi dung
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        phone: '',
        gender: '',
        type: '',
        token: '',
        cart: [],
      );
      http.Response res = await http.post(
        Uri.parse(signup),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
              context,
              'Account created! Login with the same credentials!',
              Colors.green);
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString(), Colors.yellow);
    }
  }

  //ham dang nhap nguoi dung
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse(signin),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          //khởi tạo lưu trữ cục bọ trên máy
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          // Navigator.pushNamed(context, HomeScreen.routeName);
          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, (route) => false);
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString(), Colors.yellow);
    }
  }

  //ham lay thong tin nguoi dùng
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      // kiem tra token
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse(tokenValid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        //get user
        http.Response userRes = await http.get(
          Uri.parse(user),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (err) {
      showSnackBar(context, err.toString(), Colors.yellow);
    }
  }
}
