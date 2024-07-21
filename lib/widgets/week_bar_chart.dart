
import 'package:expense_test_app/models/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';


import '../utils/resources/color_resources.dart';

class WeekBarChart extends StatefulWidget {
  final List<Transaction> _transactions;

  WeekBarChart({required List<Transaction> transactions}) : _transactions = transactions;

  @override 
  State<StatefulWidget> createState() => WeekBarChartState();
}

class WeekBarChartState extends State<WeekBarChart> {
  final Color _barBackgroundColor = const Color.fromARGB(255, 212, 211, 211);
  int? _touchedIndex;
  late double _total;
  List<double> _spendings = List.generate(7, (index) => 0);

  double _calculateTotal() {
    if (_spendings.isNotEmpty) {
      _spendings.clear();
      _spendings = List.generate(7, (index) => 0);
    }

    if (widget._transactions.isEmpty) {
      return 0;
    }
    double sum = 0;
    for (Transaction transaction in widget._transactions) {
      _spendings[transaction.date.weekday - 1] += transaction.amount;
      sum += transaction.amount;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    double totalExpense = _calculateTotal();
    _total = _spendings.reduce(max);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
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
                  style: TextStyle(
                    color: StyleResources.primarycolor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BarChart(
                      _mainBarData(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 22,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: [
            isTouched
                ? StyleResources.primarycolor
                : StyleResources.primarycolor
          ],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
              show: true, y: _total, 
              colors: [_barBackgroundColor]),
        ),
      ],
    );
  }


  List<BarChartGroupData> _showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return _makeGroupData(0, _spendings[0],
                isTouched: i == _touchedIndex);
          case 1:
            return _makeGroupData(1, _spendings[1],
                isTouched: i == _touchedIndex);
          case 2:
            return _makeGroupData(2, _spendings[2],
                isTouched: i == _touchedIndex);
          case 3:
            return _makeGroupData(3, _spendings[3],
                isTouched: i == _touchedIndex);
          case 4:
            return _makeGroupData(4, _spendings[4],
                isTouched: i == _touchedIndex);
          case 5:
            return _makeGroupData(5, _spendings[5],
                isTouched: i == _touchedIndex);
          case 6:
            return _makeGroupData(6, _spendings[6],
                isTouched: i == _touchedIndex);
          default:
            throw Exception('Unexpected index $i');
        }
      });

  BarChartData _mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: StyleResources.primarycolor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String? weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(
                  weekDay! + '\n' + '\$' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.white, fontFamily: 'Poppins'));
            }),
        touchCallback: (touchEvent, barTouchResponse) {
          setState(() {
            if (barTouchResponse != null &&
                barTouchResponse.spot != null &&
                touchEvent.isInterestedForInteractions) {
              _touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            } else {
              _touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
          show: true,
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => TextStyle(
              color: StyleResources.primarycolor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            margin: 16,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'M';
                case 1:
                  return 'T';
                case 2:
                  return 'W';
                case 3:
                  return 'T';
                case 4:
                  return 'F';
                case 5:
                  return 'S';
                case 6:
                  return 'S';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: false,
          ),
          rightTitles: SideTitles(
            getTextStyles: (context, value) => TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            showTitles: true,
          )),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _showingGroups(),
    );
  }
}
