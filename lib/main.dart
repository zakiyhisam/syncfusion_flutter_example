import 'package:chart_test_project/TestPage.dart';
import 'package:chart_test_project/syncfusionSample/chart.dart';
import 'package:chart_test_project/syncfusionSample/columnChart.dart';
import 'package:chart_test_project/syncfusionSample/stackedColumn.dart';
import 'package:flutter/material.dart';

import 'analyticView/averageBookingBySlotStackedColumn.dart';
import 'analyticView/bookingAmountColumnChart.dart';
import 'analyticView/bookingBySlotColumnChart.dart';
import 'analyticView/dailyRevenueStackedColumn.dart';
import 'analyticView/doughnutAnalyticChart.dart';
import 'analyticView/monthlyRevenueColumnChart.dart';
import 'analyticView/slotMontlyAverageColumnChart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotivity Partner-Side App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),

      home: const MonthlyStackedColumnChart(),

    );
  }
}
