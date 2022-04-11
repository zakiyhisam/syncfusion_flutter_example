import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticData {
  String categoryName;
  String docsId;
  String monthSelection;
  double expectedRevenue;
  double paymentReceived;
  Map<String, double> expectedRevenueData;
  Map<String, dynamic> bookingAmountData;
  Map<String, double> cashTransactionData;
  Map<String, double> onlineTransactionData;
  AnalyticData({
    this.docsId = "docId",
    required this.categoryName,
    required this.monthSelection,
    required this.expectedRevenue,
    required this.paymentReceived,
    required this.expectedRevenueData,
    required this.bookingAmountData,
    required this.cashTransactionData,
    required this.onlineTransactionData,
  });
  factory AnalyticData.firestoreSnapshot(
      {required DocumentSnapshot doc,
      required String categoryId,
      required String categoryName}) {
    Map _docDataMap = doc.data() as Map<dynamic, dynamic>;

    String _rawExpectedRevenue = _docDataMap['expected_revenue'].toString();
    double _expectedRevenue = double.parse(_rawExpectedRevenue);

    String _rawPaymentReceived = _docDataMap['payment_received'].toString();
    double _paymentReceived = double.parse(_rawPaymentReceived);

    Map<String, dynamic> _rawExpectedRevenueData =
        _docDataMap['expected_revenue_data'];
    Map<String, double> _expectedRevenueData = _rawExpectedRevenueData
        .map((key, value) => MapEntry(key, double.parse(value.toString())));

    Map _rawBookingAmountData = _docDataMap['booking_amount_data'];
    Map<String, dynamic> _bookingAmountData =
        _rawBookingAmountData.map((key, value) => MapEntry('$key', value));

    Map<String, dynamic> _rawCashTransactionData =
        _docDataMap['cash_transaction_data'];
    Map<String, double> _cashTransactionData =
        _rawCashTransactionData.map((key, value) => MapEntry(key, value));

    Map _rawOnlineTransactionData = _docDataMap['online_transaction_data'];
    Map<String, double> _onlineTransactionData =
        _rawOnlineTransactionData.map((key, value) => MapEntry('$key', value));

    return AnalyticData(
        docsId: categoryId,
        categoryName: categoryName,
        monthSelection: _docDataMap['month_selection'],
        expectedRevenue: _expectedRevenue,
        paymentReceived: _paymentReceived,
        expectedRevenueData: _expectedRevenueData,
        bookingAmountData: _bookingAmountData,
        cashTransactionData: _cashTransactionData,
        onlineTransactionData: _onlineTransactionData);
  }
  factory AnalyticData.fromJson(
      Map<String, dynamic> jSonData, String categoryName) {
    String _rawExpectedRevenue = jSonData['expected_revenue'].toString();
    double _expectedRevenue = double.parse(_rawExpectedRevenue);

    String _rawPaymentReceived = jSonData['payment_received'].toString();
    double _paymentReceived = double.parse(_rawPaymentReceived);

    Map<String, dynamic> _rawExpectedRevenueData =
        jSonData['expected_revenue_data'];
    Map<String, double> _expectedRevenueData = _rawExpectedRevenueData
        .map((key, value) => MapEntry(key, double.parse(value.toString())));

    Map _rawBookingAmountData = jSonData['booking_amount_data'];
    Map<String, dynamic> _bookingAmountData =
        _rawBookingAmountData.map((key, value) => MapEntry('$key', value));

    Map<String, dynamic> _rawCashTransactionData =
        jSonData['cash_transaction_data'];
    Map<String, double> _cashTransactionData =
        _rawCashTransactionData.map((key, value) => MapEntry(key, value));

    Map _rawOnlineTransactionData = jSonData['online_transaction_data'];
    Map<String, double> _onlineTransactionData =
        _rawOnlineTransactionData.map((key, value) => MapEntry('$key', value));

    return AnalyticData(
        categoryName: categoryName,
        docsId: jSonData['court_id'],
        monthSelection: jSonData['month_selection'],
        expectedRevenue: _expectedRevenue,
        paymentReceived: _paymentReceived,
        expectedRevenueData: _expectedRevenueData,
        bookingAmountData: _bookingAmountData,
        cashTransactionData: _cashTransactionData,
        onlineTransactionData: _onlineTransactionData);
  }
  Map<String, dynamic> toJson() => {
        'month_selection': monthSelection,
        'expected_revenue': expectedRevenue,
        'payment_received': paymentReceived,
        'expected_revenue_data': expectedRevenueData,
        'booking_amount_data': bookingAmountData,
        'cash_transaction_data': cashTransactionData,
        'online_transaction_data': onlineTransactionData,
      };
  static Map<String, int> genBookingAmountData() {
    Map<String, int> returnData = {};
    for (var i = 8; i < 24; i++) {
      returnData[i.toString()] = getMiniRandom();
    }
    return returnData;
  }

  static List<AnalyticData> mockAnalyticData() {
    List<AnalyticData> returnData = [];
    for (var i = 0; i < 10; i++) {
      Map<String, double> _expectedRevenueData = {};
      Map<String, double> _cashTransactionData = {};
      Map<String, double> _onlineTransactionData = {};
      double _expectedRevenue = 0;
      double _paymentReceived = 0;
      Map<String, dynamic> _bookingAmountData = {};
      for (var i = 0; i < 30; i++) {
        double _randomRevenue = getRandom().toDouble();
        _expectedRevenueData[(i + 1).toString()] = _randomRevenue;
        _expectedRevenue += _randomRevenue;

        double _randomCash = getSmallRandom().toDouble();
        _cashTransactionData[(i + 1).toString()] = _randomCash;

        double _randomOnline = getSmallRandom().toDouble();
        _onlineTransactionData[(i + 1).toString()] = _randomOnline;

        _paymentReceived += _randomCash;
        _paymentReceived += _randomOnline;

        _bookingAmountData[(i + 1).toString()] = genBookingAmountData();
      }

      AnalyticData data = AnalyticData(
          categoryName: 'Court #${i + 1}',
          docsId: 'categoryId #${i + 1}',
          monthSelection: '2022APR',
          expectedRevenue: _expectedRevenue,
          paymentReceived: _paymentReceived,
          expectedRevenueData: _expectedRevenueData,
          onlineTransactionData: _onlineTransactionData,
          cashTransactionData: _cashTransactionData,
          bookingAmountData: _bookingAmountData);
      returnData.add(data);
    }
    return returnData;
  }

  static Map<String, dynamic> mockCategoryCapacity() {
    Map<String, int> returnData = {};
    Random rnd;
    int min = 10;
    int max = 12;
    rnd = Random();
    for (var i = 0; i < 10; i++) {
      returnData['Court #${i + 1}'] = (min + rnd.nextInt(max - min));
    }
    return returnData;
  }

  static int getRandom() {
    Random rnd;
    int min = 0;
    int max = 100;
    rnd = Random();
    return (min + rnd.nextInt(max - min)) * 100;
  }

  static int getSmallRandom() {
    Random rnd;
    int min = 0;
    int max = 10;
    rnd = Random();
    return (min + rnd.nextInt(max - min)) * 100;
  }

  static int getMiniRandom() {
    Random rnd;
    int min = 0;
    int max = 10;
    rnd = Random();
    return (min + rnd.nextInt(max - min));
  }
}
