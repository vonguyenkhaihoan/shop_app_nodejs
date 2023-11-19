import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:shop_app/config/config.dart';
import 'package:http/http.dart' as http;

class TotalRevenueChart extends StatefulWidget {
  const TotalRevenueChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TotalRevenueChartState();
}

class TotalRevenueChartState extends State<TotalRevenueChart> {
  List<CategoryData> categoryData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.8:3000/revenue-by-month'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categoryData = data.map((item) => CategoryData.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  // Future<void> fetchData() async {
  // try {
  //   final data = await AdminServices.fetchData();
  //   setState(() {
  //     categoryData = data;
  //   });
  // } catch (e) {
  //   // Handle exceptions
  //   print('Error fetching data: $e');
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return BarChartSample(categoryData: categoryData);
  }
}

class CategoryData {
  final String name;
  final double monthlyRevenue;

  CategoryData({required this.name, required this.monthlyRevenue});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      name: json['month'],
      monthlyRevenue: json['monthlyRevenue'].toDouble(),
    );
  }
}

class BarChartSample extends StatefulWidget {
  final List<CategoryData> categoryData;

  const BarChartSample({Key? key, required this.categoryData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<BarChartSample> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: charts.BarChart(
                      _createBarChartSeries(),
                      animate: true,
                      defaultRenderer: charts.BarRendererConfig<String>(
                        groupingType: charts.BarGroupingType.grouped,
                        strokeWidthPx: 2.0, // Adjust the width of the bars
                        barRendererDecorator: charts.BarLabelDecorator<String>(
                          insideLabelStyleSpec: charts.TextStyleSpec(
                            fontSize: 10, // Adjust the font size of the labels
                            color: charts.ColorUtil.fromDartColor(Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<charts.Series<CategoryData, String>> _createBarChartSeries() {
    return [
      charts.Series<CategoryData, String>(
        id: 'Revenue-by-moth',
        data: widget.categoryData,
        domainFn: (CategoryData data, _) => data.name,
        measureFn: (CategoryData data, _) => data.monthlyRevenue,
        // colorFn: (_, __) => charts.ColorUtil.fromDartColor(categoryColors[0]),
        labelAccessorFn: (CategoryData data, _) =>
            '${data.monthlyRevenue.toString()}', // Add percentage label
      ),
    ];
  }
}
