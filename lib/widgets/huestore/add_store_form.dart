import 'package:flutter/material.dart';
import 'package:hueganizer/models/store_model.dart';

class AddStoreForm extends StatefulWidget {
  final Function onSavePressed;
  final bool minimizeLength;
  final StoreModel updatedStore;
  final _nameController = TextEditingController();

  final _descController = TextEditingController();

  AddStoreForm(this.onSavePressed, this.minimizeLength, this.updatedStore) {
    if (updatedStore != null ) {
      _nameController.text = updatedStore.name;
      _descController.text = updatedStore.desc;
    }
  }

  @override
  _AddStoreFormState createState() => _AddStoreFormState();
}

class _AddStoreFormState extends State<AddStoreForm> {

  void _submitForm() {
    final name = widget._nameController.text;
    final desc = widget._descController.text;

    if (name.isEmpty) {
      return;
    }
    if (widget.updatedStore == null) {
      widget.onSavePressed(
        name,
        desc,
      );
    } else {
      widget.onSavePressed(StoreModel(
        name: name,
        desc: desc,
        id: widget.updatedStore.id,
      ));
    }

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
                controller: widget._nameController,
                maxLength: widget.minimizeLength ? 14 : 30,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: widget._descController,
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
