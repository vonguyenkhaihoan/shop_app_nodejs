import 'dart:convert';

import 'package:shop_app/config/config.dart';
import 'package:shop_app/constains/error_handling.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  //lay danh mục
  Future<List<Category>> getAllCategories(BuildContext context) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Category> categoryList = [];

    try {
      http.Response res = await http
          .get(Uri.parse(apiAllCaterogy), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //chay vong lap san pham lays tudb
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            //them vao danh sach san pham
            categoryList.add(
              Category.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    return categoryList;
  }

  //tim san pham theo danh muc
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse(apiProducts + '?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    return productList;
  }

  //lay san pham nam trong top dung dau ds danh gia
  Future<List<Product>> fetchTopRateProducts({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse(apiTopRateProducts), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
    return productList;
  }

  // lay san phan dung dau ds danh gia
  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
    );

    try {
      http.Response res =
          await http.get(Uri.parse(apidealofdayProducts), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red[300]!);
    }
    return product;
  }
}
