import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final double? width;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(color: color == null ? Colors.white : Colors.black),
      ),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, 50),
        backgroundColor: color,
      ),
    );
  }
}
