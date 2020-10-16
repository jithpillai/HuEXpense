import 'package:flutter/material.dart';
import 'package:hueganizer/models/listItem.dart';
import 'package:hueganizer/models/listType.dart';
import 'package:hueganizer/providers/db_helper.dart';
import 'package:hueganizer/widgets/huelist/add_list_type.dart';
import 'package:hueganizer/widgets/huelist/huelist_item.dart';
import 'package:share/share.dart';

class ViewHueList extends StatefulWidget {
  final String listId;
  final String name;
  final String desc;
  final Function refreshMainGrid;
  bool pageDirty = false;
  final nameController = TextEditingController();
  final descController = TextEditingController();

  ViewHueList(this.listId, this.name, this.desc, this.refreshMainGrid) {
    print(this.name);
    nameController.text = this.name;
    descController.text = this.desc;
    pageDirty = false;
  }

  @override
  _ViewHueListState createState() => _ViewHueListState();
}

class _ViewHueListState extends State<ViewHueList> {
  var myCtx;
  List<ListItem> _allListItems = [];

  void _startAddForm(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return AddListType(_addListItem, false);
        });
  }

  void _addListItem(String name, String desc) {
    _insertListItem(ListItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: widget.listId,
      name: name,
      desc: desc,
      status: 'none',
    ));
  }

  void _deleteListItem(ListItem item) async {
    var i = await Database_Helper.instance.deleteListItems(item.id);
    print('Deleted $i');
    setState(() {
      _allListItems.removeWhere((element) => element.id == item.id);
    });
  }

  _insertListItem(newItem) async {
    int i = await Database_Helper.instance.insertListItems(newItem.toJson());
    print('The new item id: $i');
    _readAllItems();
  }

  _readAllItems() async {
    List<Map<String, dynamic>> queryItems =
        await Database_Helper.instance.queryListItems(widget.listId);
    List<ListItem> allItems = [];

    _allListItems.clear();
    print('All Items $queryItems');

    queryItems.forEach((element) {
      allItems.add(ListItem(
        id: element['id'],
        parentId: element['parentId'],
        name: element['name'],
        desc: element['desc'],
        status: element['status'],
      ));
    });
    setState(() {
      _allListItems.addAll(allItems);
    });
    if (allItems.length == 0) {
      _startAddForm(myCtx);
    }
  }

  void _onSubmitListSave(context) {
    final newName = widget.nameController.text;
    final newDesc = widget.descController.text;

    if (newName.isEmpty) {
      return;
    }
    _onListSavePressed(
      widget.listId,
      newName,
      newDesc,
    );
    Navigator.of(context).pop(true);
    widget.refreshMainGrid();
  }

  _onListSavePressed(listId, newName, newDesc) async {
    var listType = new ListType(
      id: listId,
      name: newName,
      desc: newDesc,
    );
    int i = await Database_Helper.instance.updateListTypes(listType.toJson());
    //_showSuccessMessage(i);
  }

  Future<bool> _onWillPop() async {
    if (!widget.pageDirty) {
      return true;
    }

    return (await showDialog(
          context: myCtx,
          builder: (ctx) => new AlertDialog(
            title: new Text('Confirmation'),
            content: new Text('Do you want to save the changes (if any)?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () =>
                    Navigator.of(ctx).pop(true), //false will stop the pop
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  _onSubmitListSave(ctx);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  String _getListToString() {
    String fullMessage = '*'+widget.name+' items* \n'; //* added for Whatsapp bold text

    for (var item in _allListItems) {
      fullMessage+= item.name+': '+item.desc+' \n';
    }
    print(fullMessage);
    return fullMessage;
  }

  _updateListItem(item) async {
    print(item.toJson());
    int i = await Database_Helper.instance.updateListItems(item.toJson());
    print('Updated: $i');
    _readAllItems();
  }

  Scaffold _getMainContainer(context) {
    final mediaQueryCtx = MediaQuery.of(context);
    final appBar = new AppBar(
      title: new TextField(
        controller: widget.nameController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration.collapsed(
          hintText: "Name",
        ),
        onChanged: (value) {
          widget.pageDirty = true;
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          color: Colors.white,
          onPressed: () {
            final RenderBox box = context.findRenderObject();
            Share.share(
              _getListToString(),
              subject:  widget.name,
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.save),
          color: Colors.white,
          onPressed: () {
            _onSubmitListSave(context);
          },
        ),
      ],
    );
    return new Scaffold(
      appBar: appBar,
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 80,
              child: TextField(
                controller: widget.descController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLength: 33,
                maxLengthEnforced: true,
                onChanged: (value) {
                  widget.pageDirty = true;
                },
              ),
            ),
            Container(
              height: (mediaQueryCtx.size.height -
                  appBar.preferredSize.height -
                  mediaQueryCtx.padding.top -
                  90), //Buffer Height of Desc container
              child:
                  HueListItem(_allListItems, _updateListItem, _deleteListItem),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RaisedButton(
        color: Theme.of(context).accentColor,
        child: Container(
          width: 95,
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Add Item",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          _startAddForm(context);
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readAllItems();
  }

  @override
  Widget build(BuildContext context) {
    myCtx = context;

    return WillPopScope(
      child: _getMainContainer(context),
      onWillPop: _onWillPop,
    );
  }
}
