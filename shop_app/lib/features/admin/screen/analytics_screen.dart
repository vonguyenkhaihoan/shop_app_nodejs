import 'package:shop_app/common/widgets/loader.dart';
import 'package:shop_app/features/admin/models/sales.dart';
import 'package:shop_app/features/admin/services/admin_services.dart';
import 'package:shop_app/features/admin/widgets/bartCater.dart';
import 'package:shop_app/features/admin/widgets/bartChart_CatPercen.dart';
import 'package:shop_app/features/admin/widgets/category_products_chart.dart';
import 'package:shop_app/features/admin/widgets/detail_card.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shop_app/features/admin/widgets/totalRevenum_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;
  int? totalOrder;
  int? totatRevenu;
  int? totatProduct;

  @override
  void initState() {
    super.initState();
    getEarnings();
    getTotalOrder();
    getTotalRevenu();
    getTotalProduct();
  }

  //lay so tien lap bieu do
  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  //lay tong so don han
  getTotalOrder() async {
    var data = await adminServices.getTotalOrder(context);
    totalOrder = data;
    setState(() {});
  }

  //tong danh thu
  getTotalRevenu() async {
    var data = await adminServices.getTotalMoneyOrder(context);
    totatRevenu = data;
    setState(() {});
  }

  //lay tong so luong san pham
  getTotalProduct() async {
    var data = await adminServices.getTotalProduct(context);
    totatProduct = data;
    setState(() {});
  }

  // lam moi giao dien
  Future<void> refresh() async {
    // Refresh product data here
    getEarnings();
    getTotalOrder();
    getTotalRevenu();
    getTotalProduct();
    setState(() {});
    return Future.delayed(Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    // print
    double screenWidth = MediaQuery.of(context).size.width;
    return earnings == null || totalSales == null
        ? const Loader()
        : LiquidPullToRefresh(
            onRefresh: refresh,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thống kế',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // thông tinh tổng quat
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailCart(
                              count: "$totalOrder",
                              title: "Total Order",
                            ),
                            detailCart(
                              count: "\$ $totatRevenu",
                              title: "Total Revenue",
                            ),
                            detailCart(
                              count: " $totatProduct",
                              title: "total product",
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // Text(
                      //   '\$$totalSales',
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // //sơ đồ
                      // SizedBox(
                      //   height: 250,
                      //   child: CategoryProductsChart(
                      //     seriesList: [
                      //       charts.Series(
                      //           id: 'Sales',
                      //           data: earnings!,
                      //           domainFn: (Sales sales, _) => sales.label,
                      //           measureFn: (Sales sales, _) => sales.earning)
                      //     ],
                      //   ),
                      // ),

                      SizedBox(
                        height: 20,
                      ),

                      //bieu do phan trăm
                      Text(
                        'Thống kế phần trăm danh mục',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 300, // Đặt một chiều cao hợp lý
                        child: BarChartCatPercent(),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //bieu do don hang theo tung thang
                      Text(
                        'Thống kế đơn hàng theo từng tháng',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 300, // Đặt một chiều cao hợp lý
                        child: MonthlyOrdersChart(),
                      ),

                      //bieu do don hang theo tung thang
                      Text(
                        'Thống kế danh thu theo tháng',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 300, // Đặt một chiều cao hợp lý
                        child: TotalRevenueChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
