import 'package:shop_app/common/widgets/big_text.dart';
import 'package:shop_app/common/widgets/stars.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatelessWidget {
  final Product product;
  const SearchProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }
    double avgRating = 0;
    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                // hien hinh anh
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                      height: 135,
                      width: 135,
                    ),
                  ),
                ),

                // Container(
                //   child: Image.network(
                //     product.images[0],
                //     fit: BoxFit.cover,
                //     height: 135,
                //     width: 135,
                //   ),
                // ),

                Expanded(
                  child: Container(
                    // height: Dimension.listViewTextContSize,
                    // width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(
                            text: product.name,
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 235,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Stars(
                              rating: avgRating,
                            ),
                          ),
                          SizedBox(height: 5),
                          BigText(
                            text: '\$${product.price}',
                            color: Colors.redAccent,
                          ),
                          BigText(
                            text: product.description,
                            size: 18,
                          ),
                          product.quantity == 0
                              ? Text(
                                  'Sản phẩm đã ngưng bán',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),

                //noi dung
                /*  Column(
                  children: [
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stars(
                        rating: avgRating,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '\$${product.price}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 16,
                          // color: Colors.redAccent,
                          // fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              */
              ],
            ),
          ),
        ),
      ],
    );
  }
}
