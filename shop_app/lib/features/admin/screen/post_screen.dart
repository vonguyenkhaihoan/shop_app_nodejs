import 'package:shop_app/common/widgets/big_text.dart';
import 'package:shop_app/common/widgets/loader.dart';
import 'package:shop_app/constains/global_variables.dart';
import 'package:shop_app/features/account/widgets/single_product.dart';
import 'package:shop_app/features/admin/screen/add_product_screen.dart';
import 'package:shop_app/features/admin/screen/admin_product_detail_screen.dart';
import 'package:shop_app/features/admin/services/admin_services.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class PostScren extends StatefulWidget {
  const PostScren({super.key});

  @override
  State<PostScren> createState() => _PostScrenState();
}

class _PostScrenState extends State<PostScren> {
  // bien product kieu Product()
  List<Product>? products;

  //bien adminServices kieu AdminServices()
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  // ham lay ds san pham
  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  //ham xoa san pham
  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  //ham goi trang them san pham
  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  // lam moi giao dien
  Future<void> refresh() async {
    fetchAllProducts();
    // Refresh product data here
    setState(() {});
    return Future.delayed(Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : LiquidPullToRefresh(
            onRefresh: refresh,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Quản lý sản phẩm',
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: products!.length,
                  itemBuilder: (context, index) {
                    final productData = products![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AdminProductDetailScreen.routeName,
                          arguments: products![index],
                        );
                      },
                      child: Column(
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
                              // margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  // hien hinh anh
                                  Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      child: Image.network(
                                        productData.images[0],
                                        fit: BoxFit.fitHeight,
                                        height: 135,
                                        width: 135,
                                      ),
                                    ),
                                  ),

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
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BigText(
                                              text: productData.name,
                                            ),
                                            SizedBox(height: 5),
                                            BigText(
                                              text: '\$${productData.price}',
                                              color: Colors.redAccent,
                                            ),
                                            SizedBox(height: 5),
                                            BigText(
                                              text: productData.description,
                                              size: 18,
                                            ),
                                            SizedBox(height: 5),
                                            BigText(
                                              text:
                                                  'Loại: ${productData.category}',
                                            ),
                                            productData.quantity == 0
                                                ? Text(
                                                    'Sản phẩm đã ngưng bán',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 18),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        deleteProduct(productData, index),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              //nut hanh dong noi
              floatingActionButton: FloatingActionButton(
                onPressed: navigateToAddProduct,
                tooltip: 'Add a Product',
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
    /*
          DefaultTabController(
                length: 2,
                child: LiquidPullToRefresh(
                  onRefresh: refresh,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Scaffold(
                      appBar: AppBar(
                        bottom: const TabBar(
                          tabs: [
                            Tab(text: 'Sản phẩm'),
                            Tab(text: 'Danh mục'),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          // Tab "Sản phẩm"
                          Container(
                            child: ListView.builder(
                              itemCount: products!.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // Phần tử đầu tiên, là nút "Thêm sản phẩm"
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: navigateToAddProduct,
                                      child: const Text('Thêm sản phẩm'),
                                    ),
                                  );
                                }
                                final productData = products![index - 1];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AdminProductDetailScreen.routeName,
                                      arguments: products![index],
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 0.5,
                                            ),
                                          ),
                                          // margin: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [
                                              // hien hinh anh
                                              Container(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20)),
                                                  child: Image.network(
                                                    productData.images[0],
                                                    fit: BoxFit.contain,
                                                    height: 135,
                                                    width: 135,
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: Container(
                                                  // height: Dimension.listViewTextContSize,
                                                  // width: 200,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        BigText(
                                                          text:
                                                              productData.name,
                                                        ),
                                                        SizedBox(height: 5),
                                                        SizedBox(height: 5),
                                                        BigText(
                                                          text:
                                                              '\$${productData.price}',
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                        BigText(
                                                          text: productData
                                                              .description,
                                                          size: 18,
                                                        ),
                                                        productData.quantity ==
                                                                0
                                                            ? Text(
                                                                'Sản phẩm đã ngưng bán',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        18),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => deleteProduct(
                                                    productData, index),
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Tab "Danh mục" (Đây là nơi bạn thay thế với danh sách danh mục của bạn)
                          Center(
                            child: Text('Nội dung danh mục điều này sẽ ở đây'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          */
  }
}
