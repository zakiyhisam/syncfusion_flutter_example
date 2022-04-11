/// Package import
import 'package:chart_test_project/analyticModel.dart';
import 'package:chart_test_project/analyticView/chartDataModel.dart';
import 'package:chart_test_project/syncfusionSample/dougnutChart.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

import 'facilityAnalyticDataModel.dart';

/// Renders the stacked column chart sample.
class MonthlyStackedColumnChart extends StatefulWidget {
  /// Creates the stacked column chart sample.
  const MonthlyStackedColumnChart({Key? key}) : super(key: key);

  @override
  _MonthlyStackedColumnChartState createState() =>
      _MonthlyStackedColumnChartState();
}

/// State class of the stacked column chart.
class _MonthlyStackedColumnChartState extends State<MonthlyStackedColumnChart> {
  //_StackedColumnChartState();
  FacilityAnalyticData analyticData = FacilityAnalyticData.mockData;
  //List<AnalyticData> analyticData = AnalyticData.mockAnalyticData();
  late ChartRequirements chartRequirements;

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    chartRequirements = DailyRevenueStackedColumnViewModel.filterRevenue(
        analyticData.monthlyReport, analyticData.categoryInfoList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedColumnChart();
  }

  /// Returns the cartesian Stacked column chart.
  SfCartesianChart _buildStackedColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Daily Chart'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(
            text: 'Date',
            textStyle: const TextStyle(
                color: Colors.deepOrange,
                fontFamily: 'Roboto',
                fontSize: 16,
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300)),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          title: AxisTitle(
              text: 'Revenue (RM)',
              textStyle: const TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  //fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300)),
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          //maximum: 300,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of chart serie which need to render
  /// on the stacked column chart.
  List<StackedColumnSeries<ChartData, String>> _getStackedColumnSeries() {
    return <StackedColumnSeries<ChartData, String>>[
      for (var i = 0; i < chartRequirements.courtNameList.length; i++)
        StackedColumnSeries<ChartData, String>(
            dataSource: chartRequirements.chartValueList,
            xValueMapper: (ChartData sales, _) => sales.x,
            yValueMapper: (ChartData sales, _) => sales.yList![i],
            name: chartRequirements.courtNameList[i])
    ];
  }

  @override
  void dispose() {
    chartRequirements =
        ChartRequirements(chartValueList: [], courtNameList: []);
    super.dispose();
  }
}

class DailyRevenueStackedColumnViewModel {
  static ChartRequirements sortRevenueData(List<AnalyticData> data) {
    List<String> courtNameList = [];
    List<ChartData> returnList = [];
    for (var i = 0; i < data.length; i++) {
      String courtName = data[i].categoryName;
      courtNameList.add(courtName);
      Map<String, double> onlineData = data[i].onlineTransactionData;
      Map<String, double> cashData = data[i].cashTransactionData;
      Map<String, double> totalRevenue = {};
      onlineData.forEach((key, value) {
        totalRevenue[key] = value;
      });
      cashData.forEach((key, value) {
        totalRevenue[key] = (totalRevenue[key] ?? 0) + value;
      });

      if (returnList.isEmpty) {
        totalRevenue.forEach((key, value) {
          ChartData _data = ChartData(x: key, yList: [value]);
          returnList.add(_data);
        });
      } else {
        totalRevenue.forEach((key, value) {
          int _xIndex = returnList.indexWhere((element) => element.x == key);
          returnList[_xIndex].yList!.add(value);
        });
      }
    }
    return ChartRequirements(
        chartValueList: returnList, courtNameList: courtNameList);
  }

  static ChartRequirements filterRevenue(
      List<MonthlyReport> data, List<CategoryInfo> categoryInfo) {
    List<ChartData> _chartDataList = [];
    List<String> _courtNameList = [];
    for (MonthlyReport _data in data) {
      print(_data.toString());
      String _x = _data.month;
      List<double> _yList = [];
      _data.onlineRevenueData.sort((a, b) => a.courtId.compareTo(b.courtId));
      for (Revenue _onlineRevenue in _data.onlineRevenueData) {
        for (Revenue _cashRevenue in _data.cashRevenueData) {
          if (_courtNameList.length != _data.onlineRevenueData.length) {
            if (_onlineRevenue.courtId == _cashRevenue.courtId) {
              String categoryName = categoryInfo
                  .singleWhere(
                      (element) => element.categoryId == _onlineRevenue.courtId)
                  .categoryName;
              _courtNameList.add(categoryName);
              double _y = _onlineRevenue.value + _cashRevenue.value;
              _yList.add(_y);
            }
          } else {
            if (_onlineRevenue.courtId == _cashRevenue.courtId) {
              double _y = _onlineRevenue.value + _cashRevenue.value;
              _yList.add(_y);
            }
          }
        }
      }
      ChartData _chartData = ChartData(x: _x, yList: _yList);
      _chartDataList.add(_chartData);
    }
    return ChartRequirements(
        chartValueList: _chartDataList, courtNameList: _courtNameList);
  }
}

class ChartRequirements {
  List<ChartData> chartValueList;
  List<String> courtNameList;
  ChartRequirements(
      {required this.chartValueList, required this.courtNameList});
}
