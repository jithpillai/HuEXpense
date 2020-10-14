import 'package:flutter/material.dart';
import 'package:hueganizer/models/transaction.dart';
import 'package:hueganizer/widgets/huexpense/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  final bool showExpense;
  final int weekDifference;
  int chartLength = 7;

  Chart(this.recentTransactions, this.showExpense, this.weekDifference);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(chartLength, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: weekDifference + index));
      double totalSum = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          if (showExpense && recentTransactions[i].expense != 'false') {
            totalSum += recentTransactions[i].amount;
          }
          if (!showExpense && recentTransactions[i].expense == 'false') {
            totalSum += recentTransactions[i].amount;
          }
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      if (element['expense'] != 'false') {
        return previousValue + element['amount'];
      } else {
        return previousValue;
      }
    });
  }
  double get totalRecieved {
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      if (element['expense'] == 'false') {
        return previousValue + element['amount'];
      } else {
        return previousValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.only(top:5, bottom: 5, left: 20, right: 20),
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending,
                  showExpense ? Theme.of(context).accentColor : Colors.green[900],
              ),
                  
            );
          }).toList(),
        ),
      ),
    );
  }
}
