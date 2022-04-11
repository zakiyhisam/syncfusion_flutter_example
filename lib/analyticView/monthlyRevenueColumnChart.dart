import 'package:chart_test_project/analyticModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'chartDataModel.dart';

class MonthlyRevenueColumnChart extends StatefulWidget {
  const MonthlyRevenueColumnChart({Key? key}) : super(key: key);

  @override
  State<MonthlyRevenueColumnChart> createState() =>
      MonthlyRevenueColumnChartState();
}

class MonthlyRevenueColumnChartState extends State<MonthlyRevenueColumnChart> {
  List<AnalyticData> mockData = AnalyticData.mockAnalyticData();
  late List<ChartData> monthlyRevenue;
  late TooltipBehavior _tooltip;
  late List<ChartData> bookingAmount;
  late double averageRevenue;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : RM point.y');
    monthlyRevenue =
        MonthlyRevenueColumnChartViewModel.getMontlyRevenue(mockData[0]);
    averageRevenue =
        MonthlyRevenueColumnChartViewModel.getAverageRevenue(monthlyRevenue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
            enableAxisAnimation: true,
            title: ChartTitle(text: 'Monthly Revenue'),
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            primaryXAxis: CategoryAxis(
                title: AxisTitle(
                    text: 'Date',
                    textStyle: const TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        //fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300))),
            primaryYAxis: NumericAxis(
                minimum: 0,
                //interval: 10,
                title: AxisTitle(
                    text: 'RM',
                    textStyle: const TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        //fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300))),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                  dataSource: monthlyRevenue,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.yList![0],
                  // dataLabelMapper: (MonthlyRevenue data, _) =>
                  //   'RM '+ (data.revenue).toString(),
                  //dataLabelSettings: const DataLabelSettings(isVisible: true),
                  name: mockData[0].categoryName,
                  color: Colors.orange),
              // Render line series
              LineSeries<ChartData, String>(
                  dataSource: monthlyRevenue,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) =>
                      data.yList![1] + averageRevenue)
            ]));
  }
}

class MonthlyRevenueColumnChartViewModel {
  static List<ChartData> getMontlyRevenue(AnalyticData data) {
    List<ChartData> returnData = [];

    Map<String, double> onlineData = data.onlineTransactionData;
    Map<String, double> cashData = data.cashTransactionData;
    List<double> totalRevenueList = [];
    onlineData.forEach((key, value) {
      totalRevenueList.add(value);
    });
    cashData.forEach((key, value) {
      int _day = int.parse(key) - 1;
      totalRevenueList[_day] += value;
    });
    Map<String, double> sortedBookingAmount =
        getBookingAmount(data.bookingAmountData);

    for (var i = 0; i < totalRevenueList.length; i++) {
      ChartData data = ChartData(x: (i + 1).toString(), yList: [
        totalRevenueList[i],
        sortedBookingAmount[(i + 1).toString()] ?? 0
      ]);
      returnData.add(data);
    }
    return returnData;
  }

  static Map<String, double> getBookingAmount(
      Map<String, dynamic> bookingAmountData) {
    Map<String, double> returnVal = {};
    for (MapEntry e in bookingAmountData.entries) {
      //print("Key ${e.key}, Value ${e.value}");
      final bookedAmountDaily = e.value;
      double _totalAmount = 0;
      for (MapEntry f in bookedAmountDaily.entries) {
        _totalAmount += f.value;
      }
      returnVal[e.key] = _totalAmount;
    }
    print(returnVal);
    return returnVal;
  }

  static double getAverageRevenue(List<ChartData> data) {
    double totalRevenue = 0;
    double totalList = data.length.toDouble();
    for (ChartData _data in data) {
      totalRevenue += _data.yList![0];
    }
    double returnData = totalRevenue / totalList;
    return returnData;
  }
}
