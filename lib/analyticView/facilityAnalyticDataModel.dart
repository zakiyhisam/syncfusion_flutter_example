import 'package:chart_test_project/analyticModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacilityAnalyticData {
  String facilityId;
  List<CategoryInfo> categoryInfoList;
  List<AnalyticData> analyticData;
  List<MonthlyReport> monthlyReport;
  String targetMonthYear;
  FacilityAnalyticData(
      {required this.facilityId,
      required this.categoryInfoList,
      required this.analyticData,
      required this.monthlyReport,
      required this.targetMonthYear});
  static FacilityAnalyticData mockData = FacilityAnalyticData(
      facilityId: 'Id12345',
      categoryInfoList: [
        CategoryInfo(categoryName: 'name#1', categoryId: 'ID#1'),
        CategoryInfo(categoryName: 'name#2', categoryId: 'ID#2'),
        CategoryInfo(categoryName: 'name#3', categoryId: 'ID#3'),
        CategoryInfo(categoryName: 'name#4', categoryId: 'ID#4'),
        CategoryInfo(categoryName: 'name#5', categoryId: 'ID#5'),
      ],
      analyticData: AnalyticData.mockAnalyticData(),
      monthlyReport: MonthlyReport.mockData(),
      targetMonthYear: '2021NOV');
}

class CategoryInfo {
  String categoryName;
  String categoryId;
  CategoryInfo({required this.categoryName, required this.categoryId});
}

class MonthlyReport {
  String month;
  List<Revenue> onlineRevenueData;
  List<Revenue> cashRevenueData;
  MonthlyReport(
      {required this.month,
      required this.onlineRevenueData,
      required this.cashRevenueData});
  factory MonthlyReport.fromJson(Map<String, dynamic> jSonData, String docId) {
    Map _rawOnlineRevenueData = jSonData['online_revenue_data'];
    List<Revenue> _onlineRevenueData = [];
    _rawOnlineRevenueData.forEach((key, value) =>
        _onlineRevenueData.add(Revenue(courtId: key, value: value.toDouble())));
    Map _rawCashRevenueData = jSonData['cash_revenue_data'];
    List<Revenue> _cashRevenueData = [];
    _rawCashRevenueData.forEach((key, value) =>
        _cashRevenueData.add(Revenue(courtId: key, value: value.toDouble())));
    return MonthlyReport(
        month: docId,
        onlineRevenueData: _onlineRevenueData,
        cashRevenueData: _cashRevenueData);
  }
  List<MonthlyReport> fromFirestore({required DocumentSnapshot doc}) {
    Map _docDataMap = doc.data() as Map<dynamic, dynamic>;
    List<MonthlyReport> _returnData = [];
    _docDataMap.forEach((key, value) {
      _returnData.add(MonthlyReport.fromJson(value, '$key'));
    });
    return _returnData;
  }

  static List<MonthlyReport> mockData() {
    List<MonthlyReport> returnData = [];
    for (var i = 0; i < 10; i++) {
      List<Revenue> cashRevenue = [];
      List<Revenue> onlineRevenue = [];
      for (var j = 0; j < 5; j++) {
        Revenue cash = Revenue(
            courtId: 'ID#${j + 1}', value: AnalyticData.getRandom().toDouble());
        cashRevenue.add(cash);
        Revenue online = Revenue(
            courtId: 'ID#${j + 1}', value: AnalyticData.getRandom().toDouble());
        onlineRevenue.add(online);
      }
      MonthlyReport _data = MonthlyReport(
          month: 'MONTH#${i+1}',
          cashRevenueData: cashRevenue,
          onlineRevenueData: onlineRevenue);
      returnData.add(_data);
    }
    return returnData;
  }
}

class Revenue {
  String courtId;
  double value;
  Revenue({required this.courtId, required this.value});
}
