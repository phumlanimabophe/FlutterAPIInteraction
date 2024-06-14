import 'package:flutter/material.dart';
import 'package:for_django_api/view.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Crud API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Crud API Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    setState(() {
      print("pressed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const MainView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}







class GraphWidget extends StatefulWidget {
  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  List<IncomeExpenseData> data = [];

  Future<void> pickAndReadExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;

      if (fileBytes != null) {
        final workbook = xlsio.Workbook.load(fileBytes);
        final sheet = workbook.worksheets[0];

        for (int row = 1; row <= sheet.getRowCount(); row++) {
          String month = sheet.getRangeByIndex(row, 1).text;
          int incomeValue = sheet.getRangeByIndex(row, 2).number.toInt();
          int expensesValue = sheet.getRangeByIndex(row, 3).number.toInt();

          data.add(IncomeExpenseData(month, incomeValue, expensesValue));
        }

        workbook.dispose();

        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (data.isNotEmpty)
          ? charts.BarChart(
        [
          charts.Series<IncomeExpenseData, String>(
            id: 'Income',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (IncomeExpenseData data, _) => data.month,
            measureFn: (IncomeExpenseData data, _) => data.income,
            data: data,
          ),
          charts.Series<IncomeExpenseData, String>(
            id: 'Expenses',
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
            domainFn: (IncomeExpenseData data, _) => data.month,
            measureFn: (IncomeExpenseData data, _) => data.expenses,
            data: data,
          ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
      )
          : Center(child: Text('No data')),
      floatingActionButton: FloatingActionButton(
        onPressed: pickAndReadExcelFile,
        tooltip: 'Pick Excel File',
        child: Icon(Icons.file_upload),
      ),
    );
  }
}

class IncomeExpenseData {
  final String month;
  final int income;
  final int expenses;

  IncomeExpenseData(this.month, this.income, this.expenses);
}

