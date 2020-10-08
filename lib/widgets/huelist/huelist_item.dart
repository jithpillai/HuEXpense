import 'package:flutter/material.dart';
import 'package:hueganizer/models/listItem.dart';

class HueListItem extends StatefulWidget {
  final List<ListItem> _allListItems;
  final Function doUpdateListItems;
  final Function deleteListItem;

  HueListItem(this._allListItems, this.doUpdateListItems, this.deleteListItem);

  @override
  _HueListItemState createState() => _HueListItemState();
}

class _HueListItemState extends State<HueListItem> {
  _updateListItem(ListItem item) {
    widget.doUpdateListItems(item);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final ListItem item = widget._allListItems.removeAt(oldIndex);
        widget._allListItems.insert(newIndex, item);
      },
    );
  }

  void _onDeletePressed(ListItem item) {
    widget.deleteListItem(item);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.6,
      child: widget._allListItems.isEmpty
          ? Container(
              margin: EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No items added yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 250,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            )
          : ReorderableListView(
              onReorder: _onReorder,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: List.generate(
                widget._allListItems.length,
                (index) {
                  var itemKey = UniqueKey();
                  var item = widget._allListItems[index];
                  var itemJson = item.toJson();
                  print('Print: $itemJson');
                  return Dismissible(
                    key: itemKey,
                    background: Container(
                      color: item.status != 'Done' ? Colors.green : Colors.blue,
                      child: Center(
                        child: Text(
                          item.status != 'Done' ? 'Completed' : 'To Do',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        item.status = item.status == "Done" ? "none" : "Done";
                        _updateListItem(item);
                      });
                      var itemname = item.name;
                      String messaege = item.status == 'Done' ? 'Completed' : 'To Do';
                      
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("$itemname marked $messaege")));
                    },
                    child: Card(
                      key: itemKey,
                      color: item.status != 'Done' ? Colors.white : Colors.green[300],
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      elevation: 6,
                      child: ListTile(
                        leading: Icon(Icons.drag_handle),
                        title: Text(
                          item.name,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          item.desc,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: item.status != 'Done' ? Colors.grey : Colors.grey[900],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () {
                            _onDeletePressed(item);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
