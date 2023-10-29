import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constanst/utils.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400: // khi đã trùng email tạo tai khoan
      // showSnackBar(context, jsonDecode(response.body)['msg'], Colors.redAccent);
      showSnackBar(context, jsonDecode(response.body)['msg'], Colors.redAccent);


      break;
    case 500: //e mail không phu hợp
      showSnackBar(context, jsonDecode(response.body)['error'], Colors.blue);
      break;
    default:
      showSnackBar(context, response.body, Colors.pink);
  }
}