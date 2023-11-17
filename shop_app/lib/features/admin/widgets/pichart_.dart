import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PieChartSample extends StatefulWidget {
  const PieChartSample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSampleState();
}

class PieChartSampleState extends State<PieChartSample> {
  List<CategoryData> categoryData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.9:3000/api/categoriesPercentage'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        categoryData = data.map((item) => CategoryData.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Percentage'),
      ),
      body: PieChartSample2(categoryData: categoryData),
    );
  }
}

class CategoryData {
  final String name;
  final double percentage;

  CategoryData({required this.name, required this.percentage});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      name: json['name'],
      percentage: json['percentage'].toDouble(),
    );
  }
}

class PieChartSample2 extends StatefulWidget {
  final List<CategoryData> categoryData;

  const PieChartSample2({Key? key, required this.categoryData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  // Danh sách màu cố định tương ứng với từng danh mục
  final List<Color> categoryColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    // Thêm các màu khác nếu cần
  ];

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
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
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

  List<PieChartSectionData> showingSections() {
    return widget.categoryData.map((data) {
      final isTouched = widget.categoryData.indexOf(data) == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      // Lấy màu tương ứng từ danh sách màu cố định
      final color = categoryColors[widget.categoryData.indexOf(data)];

      return PieChartSectionData(
        color: color,
        value: data.percentage,
        title: '${data.percentage.toStringAsFixed(2)}%', // Limit decimal places
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }
}

/*
class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

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
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
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

  List<PieChartSectionData> showingSections() {
    return widget.categoryData.map((data) {
      final isTouched = widget.categoryData.indexOf(data) == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color:
            getRandomColor(), // Implement a function to generate different colors for each category
        value: data.percentage,
        title: '${data.percentage.toStringAsFixed(2)}%', // Limit decimal places
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }

  Color getRandomColor() {
    // Implement a function to generate different colors for each category
    // You can use a package like random_color or generate the colors manually
    // Example: return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    // Ensure that the color generation logic is consistent with the server-side logic.
    // return Colors.blue;
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
*/