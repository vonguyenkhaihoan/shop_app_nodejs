import 'dart:convert';

import 'package:shop_app/constains/utils.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      showSnackBar(context, jsonDecode(response.body)['msg'], Colors.redAccent);
      break;
    case 500: //e mail không phu hợp
      showSnackBar(context, jsonDecode(response.body)['error'], Colors.blue);
      break;
    default:
      showSnackBar(context, response.body, Colors.pink);
  }
}

// void dioErrorHandle(
//     {required Response response,
//     required BuildContext context,
//     required Function() onSuccess}) async {
//   if (response.statusCode == 200) {
//     onSuccess();
//   } else {
//     showSnackBar(
//       context,
//       response.data['message'] ?? response.statusCode.toString(),
//       Colors.red,
//     );
//   }
// }
