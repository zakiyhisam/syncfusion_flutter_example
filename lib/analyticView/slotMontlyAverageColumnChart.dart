import 'package:chart_test_project/analyticModel.dart';
import 'package:chart_test_project/analyticView/chartDataModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SlotMonthlyColumnChart extends StatefulWidget {
  const SlotMonthlyColumnChart({Key? key}) : super(key: key);

  @override
  State<SlotMonthlyColumnChart> createState() => SlotMonthlyColumnChartState();
}

class SlotMonthlyColumnChartState extends State<SlotMonthlyColumnChart> {
  final List<AnalyticData> mockData = AnalyticData.mockAnalyticData();
  late TooltipBehavior _tooltip;
  late AnalyticData currentData;
  late List<ChartData> data;
  late List<ChartData> dailyAverageList;
  @override
  void initState() {
    currentData = mockData[0];
    data = BookingBySlotColumnChartViewModel.sortData(currentData, '1');
    dailyAverageList = BookingBySlotColumnChartViewModel.getdailyAverage(
        currentData.bookingAmountData);
    _tooltip =
        TooltipBehavior(enable: true, format: 'point.x : point.y bookings');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
            enableSideBySideSeriesPlacement: false,
            title: ChartTitle(text: 'Booking By Slot With Monthly Average'),
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            primaryXAxis: CategoryAxis(
                title: AxisTitle(
                    text: 'Slot Key',
                    textStyle: const TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        //fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300))),
            primaryYAxis: NumericAxis(
                minimum: 0,
                title: AxisTitle(
                    text: 'Booking Amount',
                    textStyle: const TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        //fontStyle: FontStyle.italic,
                        fontWeight:
                            FontWeight.w300))), //, maximum: 40, interval: 10),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Booked Amount',
                  color: Colors.orange),
              ColumnSeries<ChartData, String>(
                  opacity: 0.7,
                  width: 0.4,
                  dataSource: dailyAverageList,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Daily Average',
                  color: Colors.grey)
            ]));
  }
}

class BookingBySlotColumnChartViewModel {
  static List<ChartData> sortData(AnalyticData data, String selectedDate) {
    List<ChartData> returnList = [];
    Map<String, dynamic> bookingAmountData = data.bookingAmountData;
    //print(bookingAmountData);
    for (MapEntry e in bookingAmountData.entries) {
      //print("Key ${e.key}, Value ${e.value}");
      if (e.key == selectedDate) {
        final bookedAmountDaily = e.value;
        for (MapEntry f in bookedAmountDaily.entries) {
          ChartData _processedData = ChartData(x: f.key, y: f.value);
          returnList.add(_processedData);
        }
      }
    }
    return returnList;
  }

  static List<ChartData> getdailyAverage(
      Map<String, dynamic> bookingAmountData) {
    List<ChartData> _dataList = [];
    bool hasAdded = false;
    double totalDay = 0;
    for (MapEntry e in bookingAmountData.entries) {
      final selectedData = e.value;
      if (hasAdded == false) {
        for (MapEntry f in selectedData.entries) {
          ChartData newData = ChartData(x: f.key, y: f.value);
          _dataList.add(newData);
          hasAdded = true;
        }
      } else {
        for (MapEntry f in selectedData.entries) {
          int _index = _dataList.indexWhere((element) => element.x == f.key);
          _dataList[_index].y = (_dataList[_index].y ?? 0) + f.value;
        }
      }
      totalDay += 1;
    }
    for (var i = 0; i < _dataList.length; i++) {
      _dataList[i].y = _dataList[i].y! / totalDay;
    }
    return _dataList;
  }
}

class _ChartData {
  _ChartData(
    this.x,
    this.y,
  ); // this.y1);

  final String x;
  final double y;
  //final double? y1;
}
