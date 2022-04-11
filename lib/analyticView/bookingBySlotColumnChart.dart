import 'package:chart_test_project/analyticModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BookingBySlotColumnChart extends StatefulWidget {
  const BookingBySlotColumnChart({Key? key}) : super(key: key);

  @override
  State<BookingBySlotColumnChart> createState() =>
      BookingBySlotColumnChartState();
}

class BookingBySlotColumnChartState extends State<BookingBySlotColumnChart> {
  final List<AnalyticData> mockData = AnalyticData.mockAnalyticData();
  late TooltipBehavior _tooltip;
  late AnalyticData currentData;
  late List<_ChartData> data;
  late double dailyAverage;
  @override
  void initState() {
    currentData = mockData[0];
    data = BookingBySlotColumnChartViewModel.sortData(currentData, '1');
    dailyAverage = BookingBySlotColumnChartViewModel.getdailyAverage(
        currentData.bookingAmountData, '1');
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
            title: ChartTitle(text: 'Booking By Slot'),
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
            series: <ChartSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  name: 'Booked Amount',
                  color: Colors.orange),
              ColumnSeries<_ChartData, String>(
                  opacity: 0.9,
                  width: 0.4,
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => dailyAverage,
                  name: 'Daily Average',
                  color: Colors.grey)
            ]));
  }
}

class BookingBySlotColumnChartViewModel {
  static List<_ChartData> sortData(AnalyticData data, String selectedDate) {
    List<_ChartData> returnList = [];
    Map<String, dynamic> bookingAmountData = data.bookingAmountData;
    //print(bookingAmountData);
    for (MapEntry e in bookingAmountData.entries) {
      //print("Key ${e.key}, Value ${e.value}");
      if (e.key == selectedDate) {
        final bookedAmountDaily = e.value;
        for (MapEntry f in bookedAmountDaily.entries) {
          _ChartData _processedData = _ChartData(f.key, f.value);
          returnList.add(_processedData);
        }
      }
    }
    return returnList;
  }

  static double getdailyAverage(
      Map<String, dynamic> bookingAmountData, String selectedDate) {
    double returnVal = 0;
    double totalSlot = 0;
    double totalBookingAmount = 0;
    for (MapEntry e in bookingAmountData.entries) {
      if (e.key == selectedDate) {
        final selectedData = e.value;
        for (MapEntry f in selectedData.entries) {
          totalSlot += 1;
          totalBookingAmount += f.value;
        }
      }
    }
    if (totalSlot != 0) {
      returnVal = totalBookingAmount / totalSlot;
    }
    return returnVal;
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
