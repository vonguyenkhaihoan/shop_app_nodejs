import 'dart:convert';

import 'package:shop_app/config/config.dart';
import 'package:shop_app/constains/error_handling.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/auth/screens/auth_screen.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileServices {
  //log out
  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red[300]!);
    }
  }

  // update user
  // void saveUserUpdate({
  //   required BuildContext context,
  //   required String address,
  //   required String name,
  //   required String phone,
  //   required String gender,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);

  //   try {
  //     http.Response res = await http.post(
  //       Uri.parse(apiUpdateUser),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': userProvider.user.token,
  //       },
  //       body: jsonEncode({
  //         'address': address,
  //         'name': name,
  //         'phone': phone,
  //         'gender': gender
  //       }),
  //     );

  //     httpErrorHandle(
  //       response: res,
  //       context: context,
  //       onSuccess: () {
  //         User user = userProvider.user.copyWith(
  //           address: jsonDecode(res.body)['address'],
  //           name: jsonDecode(res.body)['name'],
  //           phone: jsonDecode(res.body)['phone'],
  //           gender: jsonDecode(res.body)['gender'],
  //         );
  //         userProvider.setUserFromModel(user);
  //         Navigator.pop(context);
  //         showSnackBar(context, 'Update successfully', Colors.green);
  //       },
  //     );
  //   } catch (e) {
  //     showSnackBar(
  //         context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
  //   }
  // }

  void saveUserUpdate({
    required BuildContext context,
    required String address,
    required String name,
    required String phone,
    required String gender,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse(apiUpdateUser),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
          'name': name,
          'phone': phone,
          'gender': gender
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
            name: jsonDecode(res.body)['name'],
            phone: jsonDecode(res.body)['phone'],
            gender: jsonDecode(res.body)['gender'],
          );
          userProvider.setUserFromModel(user);
          Navigator.pop(context);
          showSnackBar(context, 'Update successfully', Colors.green);
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }
}
