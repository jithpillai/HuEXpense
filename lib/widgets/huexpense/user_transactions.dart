import 'package:flutter/material.dart';
import 'package:hueganizer/models/transaction.dart';

class UserTransactions extends StatefulWidget {
  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _allTransactions = [
    Transaction(
      id: 1,
      title: "Gift Amount",
      amount: 200,
      date: DateTime.now(),
    ),
    Transaction(
      id: 2,
      title: "Online Spent",
      amount: 2000,
      date: DateTime.now(),
    ),
    Transaction(
      id: 3,
      title: "Fuel Charges",
      amount: 500,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String title, double amount) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().millisecondsSinceEpoch,
      date: DateTime.now(),
    );

    setState(() {
      _allTransactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //NewTransaction(_addNewTransaction),
        //TransactionList(_allTransactions),
      ],
    );
  }
}
