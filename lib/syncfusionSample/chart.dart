import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatefulWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  late TooltipBehavior _tooltipBehavior;
  
  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          // Initialize category axis
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Sales analysis'),
          legend: Legend(isVisible: true ,position: LegendPosition.bottom),
          tooltipBehavior: _tooltipBehavior,
            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                // Bind data source
                dataSource:  <SalesData>[
                  SalesData('Jan', 35),
                  SalesData('Feb', 28),
                  SalesData('Mar', 34),
                  SalesData('Apr', 32),
                  SalesData('May', 40)
                ],
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales,
                dataLabelSettings: const DataLabelSettings(isVisible: true)
              )
            ]
        )
      )
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}