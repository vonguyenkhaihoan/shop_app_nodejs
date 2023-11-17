import 'package:shop_app/common/widgets/loader.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/home/services/home_services.dart';
import 'package:shop_app/features/product_details/screens/product_detail_screen.dart';
import 'package:shop_app/features/search/widgets/search_product.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({super.key, required this.category});

  @override
  State<CategoryDealsScreen> createState() => __CategoryDealsScreenState();
}

class __CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

// hàm lay san pham thep danh much
  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  Future<void> refreshProducts() async {
    // Refresh product data here
    setState(() {});
    return Future.delayed(Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),

      //body
      body: productList == null
          ? Loader()
          : LiquidPullToRefresh(
              onRefresh: refreshProducts,
              child: Column(
                children: [
                  //Keep shopping for caterory
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Keep shopping for ${widget.category}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),

                  //
                  Expanded(
                    child: ListView.builder(
                      itemCount: productList!.length,
                      itemBuilder: (context, index) {
                        final product = productList![index];
                        final isOutOfStock = product.quantity == 0;
                        return GestureDetector(
                          onTap: isOutOfStock
                              ? () {
                                  showSnackBar(context, "Sản phẩm đã ngưng bán",
                                      Colors.yellow);
                                } // Disable interaction for out-of-stock products
                              : () {
                                  Navigator.pushNamed(
                                    context,
                                    ProductDetailScreen.routeName,
                                    arguments: product,
                                  );
                                },
                          child: SearchProduct(
                            product: productList![index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
