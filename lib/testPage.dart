import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
/// FOR TESTING PURPOSE ONLY
/// By clicking the button, a function/ method is called
/// Please put your line of code inside of the [callbackFunction]
/// Use for single functionality test
/// Does not return anything
/// The test must consist of log print, and it should be carried manually

class TestButtonSingularFunction extends StatelessWidget {
  const TestButtonSingularFunction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: callbackFunction,
                child: Text('TEST'),
              ),
            ),
          ),
        );
      },
    );
  }
}

void callbackFunction() async {
  print('pressed!');
}

//Done
