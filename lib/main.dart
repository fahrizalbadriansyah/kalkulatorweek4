import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();
  TextEditingController operatorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Minggu 4"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: num1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Bilangan 1"),
            ),
            TextField(
              controller: num2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Bilangan 2"),
            ),
            TextField(
              controller: operatorController,
              decoration: InputDecoration(labelText: "Operasi (+, -, *, /)"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calculate,
              child: Text("Hitung"),
            ),
            ElevatedButton(
              onPressed: _showResultPage,
              child: Text("Lihat Hasil"),
            ),
          ],
        ),
      ),
    );
  }

  void _calculate() async {
    double? num1 = double.tryParse(num1Controller.text);
    double? num2 = double.tryParse(num2Controller.text);
    String operator = operatorController.text;

    if (num1 != null && num2 != null && operator.isNotEmpty) {
      double result;
      if (operator == "+") {
        result = num1 + num2;
      } else if (operator == "-") {
        result = num1 - num2;
      } else if (operator == "*") {
        result = num1 * num2;
      } else if (operator == "/") {
        result = num1 / num2;
      } else {
        // Invalid operator
        return;
      }

      // Simpan hasil ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('result', result);
      prefs.setString('operator', operator);

      // Reset input fields
      num1Controller.clear();
      num2Controller.clear();
      operatorController.clear();
    }
  }

  void _showResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen()),
    );
  }
}

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double? result;
  String? operator;

  @override
  void initState() {
    _loadResult();
    super.initState();
  }

  void _loadResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      result = prefs.getDouble('result') ?? 0.0;
      operator = prefs.getString('operator') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasil Operasi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hasil Operasi Aritmatika:"),
            Text("Operator: $operator"),
            Text("Hasil: $result"),
          ],
        ),
      ),
    );
  }
}