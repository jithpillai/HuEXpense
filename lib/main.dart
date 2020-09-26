import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_xpense/widgets/chart.dart';
import 'package:hue_xpense/widgets/new_transaction.dart';
import 'package:hue_xpense/widgets/transaction_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './models/transaction.dart';
import './providers/db_helper.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
  double totalExpense = 0.0;
  double weeklyExpense = 0.0;
  List<Transaction> get _recentTransaction {
    return _allTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime txDate) async {
    final newTx = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().millisecondsSinceEpoch,
      date: txDate,
    );
    setState(() {
      //_allTransactions.add(newTx);
      _addTransaction(newTx);
    });
  }

  void _deleteTransaction(txId) async {
    var i = await Database_Helper.instance.deleteTX(txId);
    print('Deleted object $i');
    setState(() {
      _allTransactions.removeWhere((element) => element.id == txId);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  _addTransaction(newTx) async {
    final prefs = await SharedPreferences.getInstance();
    int i = await Database_Helper.instance.insertTx(newTx.toJson());
    print('The new transaction id: $i');
    _readTransactions();
    prefs.setString('allTransactions', jsonEncode(_allTransactions));
  }

  _readTransactions() async {
    //final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> queryTXs =
        await Database_Helper.instance.queryAllTx();
    _allTransactions.clear();
    List<Transaction> allItems = [];
    final weekDay = DateTime.now().subtract(Duration(days: 7));
    double totalExp = 0.0;
    double weeklyExp = 0.0;
    var dateValue;

    print('All Transactions $queryTXs');

    queryTXs.forEach((element) {
      dateValue = DateTime.fromMillisecondsSinceEpoch(int.parse(element['date']));
      totalExp += element['amount'];
      if (dateValue.isAfter(weekDay)) {
        weeklyExp += element['amount'];
      }
      allItems.add(Transaction(
        id: element['id'],
        title: element['title'],
        amount: element['amount'],
        date: dateValue,
      ));
    });
    setState(() {
      _allTransactions.addAll(allItems);
      totalExpense = totalExp;
      weeklyExpense = weeklyExp;
    });
    
    //return jsonDecode(prefs.getString('allTransactions'));
  }

  @override
  Widget build(BuildContext context) {
    _readTransactions();
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
            Center(child: Text('Total Expenses: $totalExpense',),),
            Center(child: Text('Weekly Expenses: $weeklyExpense', style: TextStyle(fontSize: 18,),),),
            Container(
              width: double.infinity,
              height: (mediaQueryCtx.size.height -
                      appBar.preferredSize.height -
                      mediaQueryCtx.padding.top) *
                  0.3,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              child: Chart(_recentTransaction),
            ),
            //NewTransaction(_addNewTransaction),
            Container(
              height: (mediaQueryCtx.size.height -
                      appBar.preferredSize.height -
                      mediaQueryCtx.padding.top) *
                  0.6,
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
