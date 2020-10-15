import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function onAddPressed;
  final DateTime selectedDate;

  NewTransaction(this.onAddPressed, this.selectedDate);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime pickedDate;

  String expense = 'true';

  void _submitTransaction() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }
    widget.onAddPressed(title, amount, pickedDate, expense);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    var nowDate = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: DateTime(nowDate.year),
      lastDate: nowDate,
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        pickedDate = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                /* onChanged: (value) {
                        titleInput = value;
                      }, */
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitTransaction(),
                //onChanged: (value) => amountInput = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: ' + DateFormat.yMd().format(pickedDate)),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Change Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _presentDatePicker();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Expense',
                    style: TextStyle(
                      fontSize: 18,
                      color: expense == 'true' ? Colors.red[900] : Colors.black,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Switch(
                    value: expense != 'true',
                    onChanged: (value) {
                      setState(() {
                        expense = value ? 'false' : 'true';
                        print(expense);
                      });
                    },
                    inactiveTrackColor: Colors.redAccent,
                    inactiveThumbColor: Colors.red[900],
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  SizedBox(width: 10,),
                  Text('Received',
                    style: TextStyle(
                      fontSize: 18,
                      color: expense == 'false' ? Colors.green[900] : Colors.black,
                    ),
                  ),
                ],
              ),
              FlatButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: _submitTransaction,
              )
            ],
          ),
        ),
      ),
    );
  }
}
