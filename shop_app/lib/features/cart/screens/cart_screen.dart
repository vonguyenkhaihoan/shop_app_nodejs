import 'package:shop_app/common/widgets/custom_button.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/address/screens/address_screen.dart';
import 'package:shop_app/features/cart/services/cart_services.dart';
import 'package:shop_app/features/cart/widgets/cart_product.dart';
import 'package:shop_app/features/cart/widgets/cart_subtotal.dart';
import 'package:shop_app/features/home/widgets/address_box.dart';
import 'package:shop_app/features/product_details/screens/product_detail_screen.dart';
import 'package:shop_app/features/search/screen/search_screen.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartServices cartServices = CartServices();

  // ham dieu huong tim kiem
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  // ham dieu huong den dia chi
  void navigateToAddressScreen(int sum) {
    Navigator.pushNamed(context, AddressScreen.routeName,
        arguments: sum.toString());
  }

  //ham xoa tat ca san pham co trong gio hang
  void RemoveAllCart() {
    cartServices.removeAllCart(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();

    return Scaffold(
      //app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Amazon.in',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),

      //khoong su dung Singscroll
      body: Column(
        children: [
          // dia chi
          const AddressBox(),
          //tong tien
          const CartSubtotal(),
          //button check out
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'Proceed to Buy (${user.cart.length} items)',
              // onTap: ()=>navigateToAddressScreen(sum),
              onTap: () {
                user.cart.isNotEmpty ? navigateToAddressScreen(sum) : null;
              },
              color: Colors.yellow[600],
            ),
          ),
          //button delete all product
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'Remove all (${user.cart.length} items)',
              onTap: () {
                user.cart.isNotEmpty ? RemoveAllCart() : null;
              },
              color: Colors.yellow[600],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            color: Colors.black12.withOpacity(0.08),
            height: 1,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: user.cart.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProductDetailScreen.routeName,
                      arguments: user.cart[index],
                    );
                  },
                  child: CartProduct(index: index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
