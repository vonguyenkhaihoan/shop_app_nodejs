import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/config/config.dart';
import 'package:shop_app/constanst/error_handling,.dart';
import 'package:shop_app/constanst/utils.dart';
import 'package:shop_app/features/home/screen/home_screen.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/provider/user_provider.dart';

class AuthService {
  // sign up user
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
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
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
            'Account created! Login with the same credentials!',Colors.green
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(),Colors.white);
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
              context, HomeScreen.routeName, (route) => false);
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString(), Colors.yellow);
    }
  }
}