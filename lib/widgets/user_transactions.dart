import 'package:flutter/material.dart';
import 'package:hue_xpense/models/transaction.dart';
import 'package:hue_xpense/widgets/new_transaction.dart';
import 'package:hue_xpense/widgets/transaction_list.dart';

class UserTransactions extends StatefulWidget {
  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _allTransactions = [
    Transaction(
      id: 't1',
      title: "Gift Amount",
      amount: 200,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: "Online Spent",
      amount: 2000,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: "Fuel Charges",
      amount: 500,
      date: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String title, double amount) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().toString(),
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
