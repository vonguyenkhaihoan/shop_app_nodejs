import 'package:shop_app/common/widgets/big_text.dart';
import 'package:shop_app/common/widgets/loader.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/home/screen/top_rate_list_screen.dart';
import 'package:shop_app/features/home/services/home_services.dart';
import 'package:shop_app/features/home/widgets/product_list.dart';
import 'package:shop_app/features/product_details/screens/product_detail_screen.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:flutter/material.dart';

class TopTenRate extends StatefulWidget {
  const TopTenRate({super.key});

  @override
  State<TopTenRate> createState() => _TopTenRateState();
}

class _TopTenRateState extends State<TopTenRate> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchTopRateProducts();
  }

  //ham lay danh sachs san pham
  fetchTopRateProducts() async {
    productList = await homeServices.fetchTopRateProducts(
      context: context,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return productList == null
        ? Loader()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Top Rate",
                      size: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          TopRateList.routeName,
                          arguments: "isTopRated",
                        );
                      },
                      child: Text(
                        "See more",
                        style: TextStyle(
                            color: GlobalVariables.selectedNavBarColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: productList!.length <= 3 ? productList!.length : 3,
                  itemBuilder: (context, index) {
                    final product = productList![index];
                    final isOutOfStock = product.quantity == 0;
                    return GestureDetector(
                      onTap: isOutOfStock
                          ? () {
                              showSnackBar(context, "Sản phẩm đã ngưng bán",
                                  Colors.yellow);
                            }  // Disable interaction for out-of-stock products
                          : () {
                              Navigator.pushNamed(
                                context,
                                ProductDetailScreen.routeName,
                                arguments: productList![index],
                              );
                            },
                      child: ProductList(
                        product: productList![index],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
