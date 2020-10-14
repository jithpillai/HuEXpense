import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hueganizer/widgets/app_drawer.dart';
import 'package:hueganizer/widgets/huexpense/chart.dart';
import 'package:hueganizer/widgets/huexpense/new_transaction.dart';
import 'package:hueganizer/widgets/huexpense/transaction_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/transaction.dart';
import '../../providers/db_helper.dart';

class HueXpenseRoute extends StatefulWidget {
  //String titleInput;
  //String amountInput;
  static const String routeName = '/expense';
  @override
  _HueXpenseRouteState createState() => _HueXpenseRouteState();
}

class _HueXpenseRouteState extends State<HueXpenseRoute>
    with WidgetsBindingObserver {
  final List<Transaction> _allTransactions = [];
  double totalExpense = 0.0;
  double weeklyExpense = 0.0;
  double totalReceived = 0.0;
  double weeklyReceived = 0.0;
  bool showExpense = true;
  int weekDifference = 0;
  String weekShown = 'Week';
  final List<Transaction> _recentTransaction = [];

  List<Transaction> getRecentTransaction() {
    final startDay =
        DateTime.now().subtract(Duration(days: weekDifference + 7));
    final endDay = DateTime.now().subtract(Duration(days: weekDifference));
    return _allTransactions.where((tx) {
      return (tx.date.isAfter(startDay) && tx.date.isBefore(endDay));
    }).toList();
  }

  void _refreshChartData() {
    final startDay =
        DateTime.now().subtract(Duration(days: weekDifference + 7));
    final endDay = DateTime.now().subtract(Duration(days: weekDifference));
    String startDayString = DateFormat.yMMMMd().format(startDay);
    String endDayString = DateFormat.yMMMMd().format(endDay);
    double totalExp = 0.0;
    double totalCred = 0.0;
    double weeklyExp = 0.0;
    double weeklyCred = 0.0;
    List<Transaction> recentItems = [];
    var dateValue;

    _recentTransaction.clear();
    recentItems = getRecentTransaction();
    //print('recentItems $recentItems');
    _allTransactions.forEach((element) {
      dateValue = element.date;
      if (element.expense != 'false') {
        totalExp += element.amount;
        if (dateValue.isAfter(startDay) && dateValue.isBefore(endDay)) {
          weeklyExp += element.amount;
        }
      } else {
        totalCred += element.amount;
        if (dateValue.isAfter(startDay) && dateValue.isBefore(endDay)) {
          weeklyCred += element.amount;
        }
      }
    });

    setState(() {
      totalExpense = totalExp;
      weeklyExpense = weeklyExp;
      totalReceived = totalCred;
      weeklyReceived = weeklyCred;
      weekShown = '$startDayString - $endDayString';
      _recentTransaction.addAll(recentItems);
    });
  }

  void _addNewTransaction(
      String title, double amount, DateTime txDate, String expense) async {
    final newTx = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().millisecondsSinceEpoch,
      date: txDate,
      expense: expense,
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
    _recentTransaction.clear();
    List<Transaction> allItems = [];
    List<Transaction> recentItems = [];
    final startDay =
        DateTime.now().subtract(Duration(days: weekDifference + 7));
    final endDay = DateTime.now().subtract(Duration(days: weekDifference));
    String startDayString = DateFormat.yMMMMd().format(startDay);
    String endDayString = DateFormat.yMMMMd().format(endDay);
    double totalExp = 0.0;
    double totalCred = 0.0;
    double weeklyExp = 0.0;
    double weeklyCred = 0.0;
    var dateValue;

    recentItems = getRecentTransaction();
    queryTXs.forEach((element) {
      dateValue =
          DateTime.fromMillisecondsSinceEpoch(int.parse(element['date']));
      if (element['expense'] != 'false') {
        totalExp += element['amount'];
        if (dateValue.isAfter(startDay) && dateValue.isBefore(endDay)) {
          weeklyExp += element['amount'];
        }
      } else {
        totalCred += element['amount'];
        if (dateValue.isAfter(startDay) && dateValue.isBefore(endDay)) {
          weeklyCred += element['amount'];
        }
      }

      allItems.add(Transaction(
        id: element['id'],
        title: element['title'],
        amount: element['amount'],
        date: dateValue,
        expense: element['expense'],
      ));
    });
    setState(() {
      _allTransactions.addAll(allItems);
      totalExpense = totalExp;
      weeklyExpense = weeklyExp;
      totalReceived = totalCred;
      weeklyReceived = weeklyCred;
      weekShown = '$startDayString - $endDayString';
    });
    _refreshChartData();

    //return jsonDecode(prefs.getString('allTransactions'));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _readTransactions();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    //To perform something when the app is inactive, paused or resumed

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Hue-Xpense'),
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
              /* Center(
              child: Text(
                'Total Expenses: $totalExpense',
              ),
            ),
            Center(
              child: Text(
                'Weekly Expenses: $weeklyExpense',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ), */
              Container(
                padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: showExpense,
                          onChanged: (value) {
                            setState(() {
                              showExpense = value;
                            });
                          },
                          activeTrackColor: Colors.redAccent,
                          activeColor: Colors.red[900],
                          inactiveTrackColor: Colors.lightGreenAccent,
                          inactiveThumbColor: Colors.green[900],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          showExpense ? 'Expenses' : 'Credits',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        showExpense
                            ? Text(
                                'Total:$totalExpense',
                              )
                            : Text(
                                'Total:$totalReceived',
                              ),
                        showExpense
                            ? Text(
                                'Week:$weeklyExpense',
                              )
                            : Text(
                                'Week:$weeklyReceived',
                              ),
                      ],
                    ),
                  ],
                ),
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: (mediaQueryCtx.size.height -
                        appBar.preferredSize.height -
                        mediaQueryCtx.padding.top) *
                    0.25,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Chart(_recentTransaction, showExpense, weekDifference),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left),
                      color: Colors.white,
                      onPressed: () {
                        weekDifference = weekDifference + 7;
                        print("left $weekDifference");
                        _refreshChartData();
                      },
                    ),
                    Container(
                      width: 280,
                      child: FittedBox(
                        child: Text(
                          weekShown,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    weekDifference != 0
                        ? IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            color: Colors.white,
                            onPressed: () {
                              if (weekDifference != 0) {
                                weekDifference = weekDifference - 7;
                                print("left $weekDifference");
                                _refreshChartData();
                              }
                            },
                          )
                        : SizedBox(
                            width: 48,
                          ),
                  ],
                ),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.7),
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Container(
                height: (mediaQueryCtx.size.height -
                        appBar.preferredSize.height -
                        mediaQueryCtx.padding.top) *
                    0.55,
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
        drawer: AppDrawer());
  }
}
