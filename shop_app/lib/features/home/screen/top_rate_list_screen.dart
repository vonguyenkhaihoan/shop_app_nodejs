import 'package:shop_app/common/widgets/loader.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/constains/utils.dart';
import 'package:shop_app/features/home/services/home_services.dart';
import 'package:shop_app/features/home/widgets/product_list.dart';
import 'package:shop_app/features/product_details/screens/product_detail_screen.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class TopRateList extends StatefulWidget {
  static const String routeName = '/top-rate-list';
  final String text;

  const TopRateList({super.key, required this.text});

  @override
  State<TopRateList> createState() => _TopRateListState();
}

class _TopRateListState extends State<TopRateList> {
  List<Product>? products;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchTopRateProducts();
  }

  fetchTopRateProducts() async {
    products = await homeServices.fetchTopRateProducts(
      context: context,
    );
    setState(() {});
  }

  Future<void> refresh() async {
    // Refresh product data here
    setState(() {});
    return Future.delayed(Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.text,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),

      //body
      body: products == null
          ? const Loader()
          : LiquidPullToRefresh(
              onRefresh: refresh,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products!.length,
                  itemBuilder: (context, index) {
                    final product = products![index];
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
                                arguments: products![index],
                              );
                            },
                      child: ProductList(
                        product: products![index],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
