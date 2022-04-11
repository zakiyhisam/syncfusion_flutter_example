import 'package:chart_test_project/analyticModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'chartDataModel.dart';

class BookingAmountColumnChart extends StatefulWidget {
  const BookingAmountColumnChart({Key? key}) : super(key: key);

  @override
  State<BookingAmountColumnChart> createState() =>
      BookingAmountColumnChartState();
}

class BookingAmountColumnChartState extends State<BookingAmountColumnChart> {
  final List<AnalyticData> mockData = AnalyticData.mockAnalyticData();
  late TooltipBehavior _tooltip;
  late AnalyticData currentData;
  late List<ChartData> data;
  @override
  void initState() {
    currentData = mockData[0];
    data = BookingAmountColumnChartViewModel.sortData(currentData);
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : point.y bookings');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
            title: ChartTitle(text: 'Total Booking Amount'),
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: 'Date', 
                textStyle:  const TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  //fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300
                )
              )
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              title: AxisTitle(
                text: 'Booking Amount', 
                textStyle:  const TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  //fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300
                )
              )
            ), //, maximum: 40, interval: 10),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Booked Amount',
                  color: Colors.orange)
            ]));
  }
}

class BookingAmountColumnChartViewModel {
  static List<ChartData> sortData(AnalyticData data) {
    List<ChartData> returnList = [];
    Map<String, dynamic> bookingAmountData = data.bookingAmountData;
    for (MapEntry e in bookingAmountData.entries) {
      //print("Key ${e.key}, Value ${e.value}");
      final bookedAmountDaily = e.value;
      double totalBookedAmount = 0;
      for (MapEntry f in bookedAmountDaily.entries) {
        totalBookedAmount += f.value as double;
      }
      ChartData _processedData = ChartData(x:e.key, y:totalBookedAmount);
      returnList.add(_processedData);
    }
    return returnList;
  }
}

