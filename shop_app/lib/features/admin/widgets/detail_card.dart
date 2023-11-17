
import 'package:flutter/material.dart';

class detailCart extends StatelessWidget {
  final String count;
  final String title;
  // final double width;

  const detailCart({
    super.key,
    required this.count,
    required this.title,
    // required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: width,
    //   height: 80,
    //   padding: const EdgeInsets.all(4),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(8),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.withOpacity(0.5),
    //         blurRadius: 4,
    //         spreadRadius: 2,
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         count!.toString(),
    //         style:
    //             TextStyle(color: Color.fromRGBO(62, 68, 71, 1), fontSize: 16),
    //       ),
    //       SizedBox(height: 5),
    //       Text(
    //         title!,
    //         style:
    //             TextStyle(color: Color.fromRGBO(62, 68, 71, 1), fontSize: 16),
    //       ),
    //     ],
    //   ),
    // );
    return Container(
      constraints: BoxConstraints(
        minWidth: 100,
        maxWidth: MediaQuery.of(context).size.width / 3.2,
        minHeight: 80,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style:
                TextStyle(color: Color.fromRGBO(62, 68, 71, 1), fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style:
                TextStyle(color: Color.fromRGBO(62, 68, 71, 1), fontSize: 16),
          ),
        ],
      ),
    );
  }
}
