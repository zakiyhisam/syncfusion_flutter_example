/// Package import
import 'package:chart_test_project/analyticModel.dart';
import 'package:chart_test_project/analyticView/chartDataModel.dart';
import 'package:chart_test_project/syncfusionSample/dougnutChart.dart';
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Renders the stacked column chart sample.
class AverageBookingBySlotStackedColumn extends StatefulWidget {
  /// Creates the stacked column chart sample.
  const AverageBookingBySlotStackedColumn({Key? key}) : super(key: key);

  @override
  _AverageBookingBySlotStackedColumnState createState() =>
      _AverageBookingBySlotStackedColumnState();
}

/// State class of the stacked column chart.
class _AverageBookingBySlotStackedColumnState
    extends State<AverageBookingBySlotStackedColumn> {
  //_StackedColumnChartState();
  List<AnalyticData> analyticData = AnalyticData.mockAnalyticData();
  late ChartRequirements chartRequirements;

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true);
    chartRequirements =
        AverageBookingBySlotStackedColumnViewModel.sortRevenueData(
            analyticData, AnalyticData.mockCategoryCapacity(), '1');
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
      title: ChartTitle(text: 'Average Booking By Slot'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: _tooltipBehavior,

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
              text: 'Booking %',
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

class AverageBookingBySlotStackedColumnViewModel {
  static ChartRequirements sortRevenueData(List<AnalyticData> data,
      Map<String, dynamic> categoryCapacity, String targetDate) {
    List<String> courtNameList = [];
    List<ChartData> returnList = [];
    for (var i = 0; i < data.length; i++) {
      AnalyticData currData = data[i];
      String _currCategoryName = currData.categoryName;
      courtNameList.add(_currCategoryName);
      int _capacity = categoryCapacity[_currCategoryName];
      Map<String, dynamic> currBookingAmountData = currData.bookingAmountData;
      for (MapEntry _mapData in currBookingAmountData.entries) {
        if (_mapData.key == targetDate) {
          final bookedAmountDaily = _mapData.value;
          if (returnList.isEmpty) {
            for (MapEntry _bookedBySlot in bookedAmountDaily.entries) {
              double _percentage = (_bookedBySlot.value / _capacity) * 100;
              ChartData _data =
                  ChartData(x: _bookedBySlot.key, yList: [_percentage]);
              returnList.add(_data);
            }
          } else {
            for (MapEntry _bookedBySlot in bookedAmountDaily.entries) {
              double _percentage = (_bookedBySlot.value / _capacity) * 100;
              int _index =
                  returnList.indexWhere((element) => element.x == _bookedBySlot.key);
              returnList[_index].yList!.add(_percentage);
            }
          }
        }
      }
    }
    return ChartRequirements(
        chartValueList: returnList, courtNameList: courtNameList);
  }
}

class ChartRequirements {
  List<ChartData> chartValueList;
  List<String> courtNameList;
  ChartRequirements(
      {required this.chartValueList, required this.courtNameList});
}
