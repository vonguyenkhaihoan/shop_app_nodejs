import 'dart:convert';

import 'package:shop_app/config/config.dart';
import 'package:shop_app/constains/error_handling.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartServices {
  //ham giam so luong san pham
  void removeAToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse(apiRemoveAToCart + '/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  //ham xoa tat ca san pham co trong gio hang
  void removeAllCart({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse(apiRemoveAllCart),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          showSnackBar(context, 'Xóa thanh công tất cả',
              Color.fromARGB(255, 161, 117, 113));
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  //ham xoa san pham chi dinh trong gio hang
  void removeProductToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse(apiRemoveProductToCart + '/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          showSnackBar(context, 'Xóa sản phẩm thành công!',
              const Color.fromARGB(255, 161, 117, 113));
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

}
