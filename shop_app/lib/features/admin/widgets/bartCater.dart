import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:shop_app/config/config.dart';

class MonthlyOrdersChart extends StatefulWidget {
  const MonthlyOrdersChart({Key? key}) : super(key: key);

  @override
  _MonthlyOrdersChartState createState() => _MonthlyOrdersChartState();
}

class _MonthlyOrdersChartState extends State<MonthlyOrdersChart> {
  List<int> monthlyOrders = [];

  @override
  void initState() {
    super.initState();
    fetchOrdersData();
  }

  Future<void> fetchOrdersData() async {
    try {
      final response = await http
          .get(Uri.parse(url + '/orders-per-month'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          monthlyOrders = data.cast<int>().toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return monthlyOrders.isEmpty
        ? CircularProgressIndicator()
        : BarChartSample(monthlyOrders: monthlyOrders);
  }
}

class BarChartSample extends StatelessWidget {
  final List<int> monthlyOrders;

  const BarChartSample({Key? key, required this.monthlyOrders})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: charts.BarChart(
        [
          charts.Series<int, String>(
            id: 'MonthlyOrders',
            domainFn: (_, index) => ' ${(index! + 1)}',
            measureFn: (monthlyOrders, _) => monthlyOrders,
            data: monthlyOrders,
          ),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig<String>(
          groupingType: charts.BarGroupingType.grouped,
        ),
      ),
    );
  }
}
