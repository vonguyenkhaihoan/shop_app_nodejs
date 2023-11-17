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

class ProductDetailsServices {
  //ham them san pham vao gio hang
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse(apiAddToCart),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          showSnackBar(
              context, 'Add to Cart successfully!', Colors.green[400]!);
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }

  //ham danh xep hang san pham
  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse(apirateProducts),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Navigator.pop(context);
          showSnackBar(context, 'Product review success!', Colors.green[400]!);
        },
      );
    } catch (e) {
      showSnackBar(
          context, e.toString(), const Color.fromARGB(255, 161, 117, 113));
    }
  }
}
