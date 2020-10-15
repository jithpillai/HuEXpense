import 'package:flutter/material.dart';
import 'package:hueganizer/constants/constants.dart';
import 'package:hueganizer/models/transaction.dart';
import 'package:hueganizer/widgets/huexpense/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  final String currentMode;
  final int weekDifference;
  int chartLength = 7;

  Chart(this.recentTransactions, this.currentMode, this.weekDifference);

  List<Map<String, Object>> get groupedTransactionValues {
    bool showExpense = currentMode == HueConstants.expenses;
    return List.generate(chartLength, (index) {
      final weekDay =
          DateTime.now().subtract(Duration(days: weekDifference + index));
      double totalSum = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          if (showExpense) {
            if (recentTransactions[i].expense != 'false') {
              totalSum += recentTransactions[i].amount;
            }
          } else if (currentMode == HueConstants.credits) {
            if (recentTransactions[i].expense == 'false') {
              totalSum += recentTransactions[i].amount;
            }
          } else {
            if (recentTransactions[i].expense == 'false') {
              totalSum += recentTransactions[i].amount;
            } else {
              totalSum -= recentTransactions[i].amount;
            }
          }
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
        'expense': showExpense.toString(),
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

  double get maxAmount {
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      double amount = (element['amount'] as double);
      if (amount.abs() > previousValue) {
        return amount.abs();
      } else {
        return previousValue;
      }
    });
  }

  double totalBalance() {
    double totalSpent = totalSpending;
    double totalCredit = totalRecieved;
    return totalCredit - totalSpent;
  }

  @override
  Widget build(BuildContext context) {
    bool showExpense = currentMode == HueConstants.expenses;
    bool allTrans = false;
    double totalValue;
    if (showExpense) {
      totalValue = totalSpending;
    } else if (currentMode == HueConstants.credits) {
      totalValue = totalRecieved;
    } else {
      totalValue = maxAmount;
      allTrans = true;
    }
    return Card(
      elevation: 6,
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            double amountDiff = (data['amount'] as double);
            Color barColor = Colors.green[800];
            if (amountDiff.isNegative || showExpense) {
              barColor = Colors.red[800];
            }
            totalValue = totalValue.abs(); //Remove negative signs
            amountDiff = amountDiff.abs();
            return Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ChartBar(
                data['day'],
                amountDiff,
                totalValue == 0.0
                    ? 0.0
                    : amountDiff / totalValue,
                barColor,
                allTrans
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
