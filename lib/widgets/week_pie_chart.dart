
// ignore_for_file: library_private_types_in_public_api

import 'package:expense_test_app/models/transaction_model.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

class WeekPieChart extends StatefulWidget {
  final List<Transaction> _transactions;
  const WeekPieChart({super.key, required List<Transaction> transactions})
      : _transactions = transactions;

  @override
  _WeekPieChartState createState() => _WeekPieChartState();
}

class _WeekPieChartState extends State<WeekPieChart> {
  List<double> _spendings = List.generate(7, (index) => 0);

  double _generateWeeklyReport() {
    if (_spendings.isNotEmpty) {
      _spendings.clear();
      _spendings = List.generate(7, (index) => 0);
    }
    double total = 0;
    for (Transaction transaction in widget._transactions) {
      _spendings[transaction.date.weekday - 1] += transaction.amount;
      total += transaction.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double totalExpense = _generateWeeklyReport();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Text(
                'Weekly Expenses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Total : \$${totalExpense.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: StyleResources.primarycolor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2.0,
                    centerSpaceRadius: 00.0,
                    startDegreeOffset: 130.0,
                    borderData:
                        FlBorderData(border: Border.all(), show: false),
                    sections: [
                      PieChartSectionData(
                        showTitle: false,
                        color: Colors.redAccent,
                        value: _spendings[0],
                        radius: 75.0,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        color: Colors.deepPurple,
                        value: _spendings[1],
                        radius: 75.0,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        color: Colors.grey,
                        value: _spendings[2],
                        radius: 75.0,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        color: Colors.green,
                        value: _spendings[3],
                        radius: 75.0,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        color: Colors.brown,
                        value: _spendings[4],
                        radius: 75.0,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        color: Colors.blue,
                        value: _spendings[5],
                        radius: 75.0,
                      ),
                      PieChartSectionData(
                        showTitle: false,
                        color: const Color.fromARGB(255, 164, 94, 13),
                        value: _spendings[6],
                        radius: 75.0,
                      ),
                    ],
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Indicator(
                    color: Colors.redAccent,
                    text: 'Mon',
                  ),
                  Indicator(
                    color: Colors.deepPurple,
                    text: 'Tue',
                  ),
                  Indicator(
                    color: Colors.grey,
                    text: 'Wed',
                  ),
                  Indicator(
                    color: Colors.green,
                    text: 'Thu',
                  ),
                  Indicator(
                    color: Colors.brown,
                    text: 'Fri',
                  ),
                  Indicator(
                    color: Colors.blue,
                    text: 'Sat',
                  ),
                  Indicator(
                    color: Color.fromARGB(255, 164, 94, 13),
                    text: 'Sun',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
