import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, Color color) {
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text(text),
  //     backgroundColor: color,
  //     behavior: SnackBarBehavior.floating,
  //     dismissDirection: DismissDirection.horizontal,
  //     showCloseIcon: true,
  //     duration: Duration(seconds: 5),
  //   ),
  // );
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info),
            Text(
              "Error",
            ),
          ],
        ),
        content: Text(text),
        backgroundColor: color,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close),
                Text('Close'),
              ],
            ),
            style: TextButton.styleFrom(
              // Chỉnh màu chữ thành trắng
              foregroundColor: Colors.white,
              // Chỉnh đường viền thành màu đen
              backgroundColor: Colors.black,
              // Chỉnh độ dày đường viền thành 2
              side: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              // Chỉnh độ tròn của đường viền
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      );
    },
  );
}
