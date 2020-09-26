import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_xpense/widgets/chart.dart';
import 'package:hue_xpense/widgets/new_transaction.dart';
import 'package:hue_xpense/widgets/transaction_list.dart';
import './models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HuEXpense',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _allTransactions = [];
  /*[ Transaction(
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
    ),]; */

  List<Transaction> get _recentTransaction {
    return _allTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime txDate) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().toString(),
      date: txDate,
    );

    setState(() {
      _allTransactions.add(newTx);
      _saveTransactions();
    });
  }

  void _deleteTransaction(txId) {
    setState(() {
      _allTransactions.removeWhere((element) => element.id == txId);
      _saveTransactions();
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    //print(_readTransactions());
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('allTransactions', jsonEncode(_allTransactions));
  }

  _readTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('allTransactions'));
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('HuEXpense'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        ),
      ],
    );
    final mediaQueryCtx = MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: (mediaQueryCtx.size.height -
                      appBar.preferredSize.height - mediaQueryCtx.padding.top) *
                  0.3,
              padding: EdgeInsets.all(5),
              child: Chart(_recentTransaction),
            ),
            //NewTransaction(_addNewTransaction),
            Container(
              height: (mediaQueryCtx.size.height - appBar.preferredSize.height - mediaQueryCtx.padding.top) * 0.6,
              child: TransactionList(_allTransactions, _deleteTransaction),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
    );
  }
}
