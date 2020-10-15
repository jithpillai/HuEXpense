import 'dart:convert';
import 'dart:ui';
import 'package:hueganizer/constants/constants.dart';
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
  final List<Transaction> _showList = [];
  double totalExpense = 0.0;
  double weeklyExpense = 0.0;
  double totalReceived = 0.0;
  double weeklyReceived = 0.0;
  bool showExpense = true;
  int weekDifference = 0;
  String weekShown = 'Week';
  final List<Transaction> _recentTransaction = [];
  String currentMode = HueConstants.allTransactions;

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
    List<Transaction> showItems = [];
    var dateValue;
    bool pushAll = currentMode == HueConstants.allTransactions;

    _recentTransaction.clear();
    _showList.clear();
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

    recentItems.forEach((element) {
      bool addToShowList = pushAll;
      if (!addToShowList) {
        if (currentMode == HueConstants.expenses) {
          addToShowList = element.expense != 'false';
        } else {
          addToShowList = element.expense == 'false';
        }
      }
      if (addToShowList) {
        showItems.add(Transaction(
          id: element.id,
          title: element.title,
          amount: element.amount,
          date: element.date,
          expense: element.expense,
        ));
      }
    });

    setState(() {
      totalExpense = totalExp;
      weeklyExpense = weeklyExp;
      totalReceived = totalCred;
      weeklyReceived = weeklyCred;
      weekShown = '$startDayString - $endDayString';
      _recentTransaction.addAll(recentItems);
      _showList.addAll(showItems);
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
    DateTime endDay = DateTime.now().subtract(Duration(days: weekDifference));
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addNewTransaction, endDay);
        });
  }

  _addTransaction(newTx) async {
    final prefs = await SharedPreferences.getInstance();
    int i = await Database_Helper.instance.insertTx(newTx.toJson());
    print('The new transaction id: $i');
    _readTransactions();
  }

  _readTransactions() async {
    //final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> queryTXs =
        await Database_Helper.instance.queryAllTx();
    _allTransactions.clear();
    List<Transaction> allItems = [];
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

  DropdownButton getModeDropDown() {
    Color currentColor;
    IconData currentIcon;

    if (currentMode == HueConstants.expenses) {
      currentColor = Colors.red[900];
      currentIcon = Icons.arrow_downward;
    } else if (currentMode == HueConstants.credits) {
      currentColor = Colors.green[900];
      currentIcon = Icons.arrow_upward_rounded;
    } else {
      currentColor = Colors.blue[700];
      currentIcon = Icons.double_arrow;
    }
    return DropdownButton<String>(
      value: currentMode,
      icon: Icon(
        currentIcon,
        color: currentColor,
      ),
      iconSize: 20,
      elevation: 16,
      style: TextStyle(
        color: currentColor,
        fontSize: 14,
      ),
      underline: Container(
        height: 2,
        color: currentColor,
      ),
      onChanged: (String newValue) {
        setState(() {
          currentMode = newValue;
          showExpense = newValue == HueConstants.expenses;
        });
        _refreshChartData();
      },
      items: <String>[
        HueConstants.allTransactions,
        HueConstants.expenses,
        HueConstants.credits
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
    );
  }

  Widget getTotalTxText() {
    double value;
    String label;

    if (currentMode == HueConstants.credits) {
      value = totalReceived;
      label = 'Total:';
    } else if (currentMode == HueConstants.expenses) {
      value = totalExpense;
      label = 'Total:';
    } else {
      value = totalReceived - totalExpense;
      label = 'Balance:';
    }
    return Row(
      children: [
        FittedBox(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        FittedBox(
          child: Text(
            HueConstants.currency.format(value),
            style: TextStyle(
              color: value.isNegative
                  ? Colors.red
                  : Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget getWeeklyTotal() {
    double value;
    String label = 'This Week:';

    if (currentMode == HueConstants.credits) {
      value = weeklyReceived;
    } else if (currentMode == HueConstants.expenses) {
      value = weeklyExpense;
    } else {
      value = weeklyReceived - weeklyExpense;
    }
    return Row(
      children: [
        FittedBox(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        FittedBox(
          child: Text(
            HueConstants.currency.format(value),
            style: TextStyle(
              color: value.isNegative
                  ? Colors.red
                  : Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
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
              Container(
                padding:
                    EdgeInsets.only(top: 5, left: 10, bottom: 0, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /* Switch(
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
                        ), */
                        getModeDropDown(),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        getTotalTxText(),
                        getWeeklyTotal(),
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
                child: Chart(_recentTransaction, currentMode, weekDifference),
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
                child: TransactionList(_showList, _deleteTransaction),
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
