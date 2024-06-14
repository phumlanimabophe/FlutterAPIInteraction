import 'package:flutter/material.dart';
import 'package:for_django_api/view.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';

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


class ExcelGraphScreen extends StatefulWidget {
  @override
  _ExcelGraphScreenState createState() => _ExcelGraphScreenState();
}

class _ExcelGraphScreenState extends State<ExcelGraphScreen> {
  List<FlSpot> incomeData = [];
  List<FlSpot> expensesData = [];

  Future<void> pickAndReadExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;
      var excel = Excel.decodeBytes(fileBytes!);

      List<FlSpot> income = [];
      List<FlSpot> expenses = [];

      var sheet = excel.tables[excel.tables.keys.first];
      for (var rowIndex = 1; rowIndex < sheet!.maxRows; rowIndex++) {
        var row = sheet.row(rowIndex);

        double month = rowIndex.toDouble();
        double incomeValue = double.tryParse(row[1]?.toString().replaceAll(RegExp(r'[^\d.]'), '') ?? '') ?? 0.0;
        double expensesValue = double.tryParse(row[2]?.toString().replaceAll(RegExp(r'[^\d.]'), '') ?? '') ?? 0.0;

        income.add(FlSpot(month, incomeValue));
        expenses.add(FlSpot(month, expensesValue));
      }

      setState(() {
        incomeData = income;
        expensesData = expenses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Graph Viewer'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickAndReadExcelFile,
            child: Text('Pick Excel File'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: incomeData,
                      isCurved: true,
                      colors: [Colors.green],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: expensesData,
                      isCurved: true,
                      colors: [Colors.red],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(showTitles: true),
                    leftTitles: SideTitles(showTitles: true),
                  ),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
