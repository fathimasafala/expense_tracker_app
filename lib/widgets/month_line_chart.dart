
// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables


import 'package:expense_test_app/presentation/models/transaction_model.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthLineChart extends StatefulWidget {
  final List<Transaction> transactions;

  MonthLineChart({super.key, required this.transactions});

  @override
  _MonthLineChartState createState() => _MonthLineChartState();
}

class _MonthLineChartState extends State<MonthLineChart> {
  List<double> spendings = List.generate(12, (index) => 0);

  @override
  void initState() {
    super.initState();
    calculateMonthlySpendings();
  }

  void calculateMonthlySpendings() {
    for (Transaction transaction in widget.transactions) {
      spendings[transaction.date.month - 1] += transaction.amount;
    }
  }

  double getTotalExpense() {
    return spendings.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    double totalExpense = getTotalExpense();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text(
            'Monthly Expenses',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            'Total : \$${totalExpense.toStringAsFixed(2)}',
            style: const TextStyle(
              color: StyleResources.primarycolor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 38,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 175, 175, 175),
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 175, 175, 175),
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            if (value == 0) {
              return '\$0';
            } else if (value % 1000 == 0) {
              return '\$${value ~/ 1000}K';
            } else {
              return '';
            }
          },
          margin: 8,
          reservedSize: 40,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: StyleResources.primarycolor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 16,
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'J';
              case 1:
                return 'F';
              case 2:
                return 'M';
              case 3:
                return 'A';
              case 4:
                return 'M';
              case 5:
                return 'J';
              case 6:
                return 'J';
              case 7:
                return 'A';
              case 8:
                return 'S';
              case 9:
                return 'O';
              case 10:
                return 'N';
              case 11:
                return 'D';
              default:
                return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xffe7e8ec), width: 1),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: spendings.reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            spendings.length,
            (index) => FlSpot(index.toDouble(), spendings[index]),
          ),
          isCurved: true,
          colors: [
            StyleResources.primarycolor,
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [
              StyleResources.primarycolor.withOpacity(0.3),
            ],
          ),
        ),
      ],
    );
  }
}
