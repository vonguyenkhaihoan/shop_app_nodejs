import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi hàm để chuyển sang màn hình chính sau 2 giây
    Timer(
      Duration(seconds: 2),
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Đặt màu nền của Splash Screen
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Đặt hình ảnh hoặc logo của bạn ở đây
            Image.asset(
              'assets/images/logo.png',
              width: 150.0,
              height: 150.0,
            ),
            SizedBox(height: 24.0),
            // Thêm tiêu đề hoặc bất kỳ văn bản nào khác bạn muốn hiển thị
            Text(
              'Tên ứng dụng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}