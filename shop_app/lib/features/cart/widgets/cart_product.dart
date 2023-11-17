import 'package:shop_app/features/cart/services/cart_services.dart';
import 'package:shop_app/features/product_details/services/product_detail_service.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  final CartServices cartServices = CartServices();

  //ham tang so luong co trong gio hang
  void increaseQuantity(Product product) {
    productDetailsServices.addToCart(
      context: context,
      product: product,
    );
  }

  //ham gia so luong san pham trong gio hang
  void decreaseQuantity(Product product) {
    cartServices.removeAToCart(
      context: context,
      product: product,
    );
  }

  //ham tang so luong co trong gio hang
  void removeProductToCart(Product product) {
    cartServices.removeProductToCart(
      context: context,
      product: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Column(
          children: [
            Container(
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
                  //hinh anh san pham
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.fitHeight,
                      height: 135,
                      width: 135,
                    ),
                  ),

                  //noi dung
                  Column(
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

                      //
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
                      SizedBox(height: 5),

                      //
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
                      SizedBox(height: 5),

                      //hien thi noi dung san pham
                      Container(
                        width: 235,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black12,
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => decreaseQuantity(product),
                                      child: Container(
                                        width: 35,
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.remove,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black12, width: 1.5),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child: Container(
                                        width: 35,
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Text(
                                          quantity.toString(),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => increaseQuantity(product),
                                      child: Container(
                                        width: 35,
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.add,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //delete
                              InkWell(
                                onTap: () => removeProductToCart(product),
                                child: Container(
                                  color: Colors.red,
                                  width: 35,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.delete,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
