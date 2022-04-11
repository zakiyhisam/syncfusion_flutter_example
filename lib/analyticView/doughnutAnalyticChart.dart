import 'package:chart_test_project/analyticModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnotAnalyticChart extends StatefulWidget {
  const DoughnotAnalyticChart({Key? key}) : super(key: key);

  @override
  DoughnotAnalyticChartState createState() => DoughnotAnalyticChartState();
}

class DoughnotAnalyticChartState extends State<DoughnotAnalyticChart> {
  //_DoughnutDefaultState();
  late TooltipBehavior _tooltip;
  final List<AnalyticData> sampleData =AnalyticData.mockAnalyticData();
  late List<PercentageContribution> courtContribution;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true, format: 'point.x : point.y%');
    courtContribution =
    DoughnutAnalyticChartViewModel.getContributionPercentage(sampleData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //sampleData = AnalyticData.mockAnalyticData();


    return _buildDefaultDoughnutChart();
  }

  /// Return the circular chart with default doughnut series.
  SfCircularChart _buildDefaultDoughnutChart() {
    return SfCircularChart(
      title: ChartTitle(text: 'Contribution From Each Court'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: _getDefaultDoughnutSeries(),
      tooltipBehavior: _tooltip,
    );
  }

  /// Returns the doughnut series which need to be render.
  List<DoughnutSeries<AnalyticData, String>> _getDefaultDoughnutSeries() {
    return <DoughnutSeries<AnalyticData, String>>[
      DoughnutSeries<AnalyticData, String>(
          innerRadius: '60%',
          radius: '80%',
          explode: true,
          explodeOffset: '10%',
          dataSource: sampleData,
          xValueMapper: (AnalyticData data, _) => data.categoryName,
          yValueMapper: (AnalyticData data, _) => courtContribution.singleWhere((element) => element.categoryId == data.docsId).percentage,
          dataLabelMapper: (AnalyticData data, _) =>              courtContribution
              .singleWhere((element) => element.categoryId == data.docsId)
              .percentage.toStringAsFixed(2) +' %',
              //'RM ' + (data.paymentReceived / 100).toString() + '.00',
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }
}

class PercentageContribution {
  String categoryId;
  double percentage;
  PercentageContribution({required this.categoryId, required this.percentage});
}

class DoughnutAnalyticChartViewModel {
  static List<PercentageContribution> getContributionPercentage(List<AnalyticData> data) {
    List<PercentageContribution> courtsPaymentReceived =
        data.map((e) => PercentageContribution(categoryId: e.docsId, percentage: e.paymentReceived)).toList();
    double totalPaymentReceived = 0;
    for (var i = 0; i < courtsPaymentReceived.length; i++) {
      totalPaymentReceived += courtsPaymentReceived[i].percentage;
    }
    List<PercentageContribution> returnData = courtsPaymentReceived.map((e) => PercentageContribution(categoryId: e.categoryId, percentage: e.percentage = (e.percentage / totalPaymentReceived) * 100)).toList();
    return returnData;
  }
}
