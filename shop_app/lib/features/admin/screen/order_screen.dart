import 'package:shop_app/common/widgets/big_text.dart';
import 'package:shop_app/common/widgets/loader.dart';
import 'package:shop_app/features/account/widgets/single_product.dart';
import 'package:shop_app/features/admin/services/admin_services.dart';
import 'package:shop_app/features/order_details/screen/order_detail_screen.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  // lam moi giao dien
  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  Future<void> refresh() async {
    // Refresh product data here
    fetchOrders();
    setState(() {});
    return Future.delayed(Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : LiquidPullToRefresh(
            onRefresh: refresh,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                body: ListView.builder(
                  itemCount: orders!.length,
                  itemBuilder: (context, index) {
                    final orderData = orders![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          OrderDetailScreen.routeName,
                          arguments: orderData,
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
                                        orderData.products[0].images[0],
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
                                            Text(
                                              'Địa chỉ:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(height: 5),
                                            BigText(
                                              text: orderData.address,
                                              size: 18,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Ngày Đặt:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            BigText(
                                              text: '${DateFormat().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        orderData.orderedAt),
                                              )}',
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // child: SizedBox(
                      //   height: 140,
                      //   child: SingleProduct(
                      //     image: orderData.products[0].images[0],
                      //   ),
                      // ),
                    );
                  },
                ),
              ),
            ),
          );
    // GridView.builder(
    //     itemCount: orders!.length,
    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 2),
    //     itemBuilder: (context, index) {
    //       final orderData = orders![index];
    //       return GestureDetector(
    //         onTap: () {
    //           Navigator.pushNamed(
    //             context,
    //             OrderDetailScreen.routeName,
    //             arguments: orderData,
    //           );
    //         },
    //         child: SizedBox(
    //           height: 140,
    //           child: SingleProduct(
    //             image: orderData.products[0].images[0],
    //           ),
    //         ),
    //       );
    //     },
    //   );
  }
}
