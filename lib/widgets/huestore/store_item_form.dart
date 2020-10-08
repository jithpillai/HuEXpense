import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hueganizer/models/store_item.dart';
import 'package:hueganizer/models/store_model.dart';
import 'package:hueganizer/providers/db_helper.dart';

class StoreItemForm extends StatefulWidget {
  final Function onSavePressed;
  final bool minimizeLength;
  final StoreItem updatedStoreItem;

  StoreItemForm(
      this.onSavePressed, this.minimizeLength, this.updatedStoreItem);

  @override
  _StoreItemFormState createState() => _StoreItemFormState();
}

class _StoreItemFormState extends State<StoreItemForm> {
  final _nameController = TextEditingController();
  final _countController = TextEditingController();
  String addedToList = 'false';
  BuildContext myCtx;

  void _removeFromShoppingList(StoreItem item) async {
    String itemname = item.name;
    int i = await Database_Helper.instance.deleteHueStoreListItems(item);
    print('The deleted item id: $i');
    Scaffold.of(myCtx).showSnackBar(
                          SnackBar(content: Text("$itemname removed from shopping list")));
  }

  void _submitForm() {
    final name = _nameController.text;
    final count = _countController.text;
    int finalCount = int.parse(count);
    if (name.isEmpty) {
      return;
    }
    if (widget.updatedStoreItem == null) {
      widget.onSavePressed(
        name,
        finalCount,
      );
    } else {
      print(widget.updatedStoreItem.parentId);
      StoreItem pushItem = StoreItem(
        name: name,
        count: finalCount,
        parentId: widget.updatedStoreItem.parentId,
        id: widget.updatedStoreItem.id,
        addedToList: addedToList,
      );
      if (widget.updatedStoreItem.addedToList == 'true' &&
      addedToList == 'false') {
        _removeFromShoppingList(widget.updatedStoreItem);
      }
      widget.onSavePressed(pushItem);
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.updatedStoreItem != null) {
      _nameController.text = widget.updatedStoreItem.name;
      _countController.text = widget.updatedStoreItem.count.toString();
      addedToList = widget.updatedStoreItem.addedToList;
    }
  }

  @override
  Widget build(BuildContext context) {
    myCtx = context;
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
                controller: _countController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (_) => _submitForm(),
              ),
              SizedBox(height: 10,),
              addedToList == 'true' ?
              Row(
                children: [
                  Switch(
                    value: addedToList == 'true',
                    onChanged: (value) {
                      setState(() {
                        addedToList = value ? 'true' : 'false';
                        print(addedToList);
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  SizedBox(width: 10,),
                  Text('Add to Shopping list'),
                ],
              ) : SizedBox(),
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
