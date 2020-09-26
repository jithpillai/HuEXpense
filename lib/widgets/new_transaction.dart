import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function onAddPressed;

  NewTransaction(this.onAddPressed);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime pickedDate = DateTime.now();

  void _submitTransaction() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }
    widget.onAddPressed(title, amount, pickedDate);
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
