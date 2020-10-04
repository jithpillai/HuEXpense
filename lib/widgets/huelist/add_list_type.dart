import 'package:flutter/material.dart';

class AddListType extends StatefulWidget {
  final Function onSavePressed;
  final bool minimizeLength;

  AddListType(this.onSavePressed, this.minimizeLength);

  @override
  _AddListTypeState createState() => _AddListTypeState();
}

class _AddListTypeState extends State<AddListType> {
  final _nameController = TextEditingController();

  final _descController = TextEditingController();

  void _submitForm() {
    final name = _nameController.text;
    final desc = _descController.text;

    if (name.isEmpty) {
      return;
    }
    widget.onSavePressed(name, desc,);
    Navigator.of(context).pop();
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
                controller: _nameController,
                maxLength: widget.minimizeLength ? 14 : 30,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _descController,
                maxLength: widget.minimizeLength ? 28 : 36,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onSubmitted: (_) => _submitForm(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    child: Text('Save'),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: _submitForm,
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    color: Theme.of(context).errorColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
