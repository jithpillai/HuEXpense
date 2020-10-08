import 'package:flutter/material.dart';
import 'package:hueganizer/constants/constants.dart';
import 'package:hueganizer/models/listItem.dart';
import 'package:hueganizer/models/store_item.dart';
import 'package:hueganizer/providers/db_helper.dart';

class StoreItemList extends StatefulWidget {
  final String storeId;
  final String storeName;
  final Function startUpdateForm;
  final Function _readAllItems;
  final List<StoreItem> _allStoreItems;

  StoreItemList(this.storeId, this.storeName, this._allStoreItems, this.startUpdateForm, this._readAllItems);

  @override
  _StoreItemListState createState() => _StoreItemListState();
}

class _StoreItemListState extends State<StoreItemList> {
  BuildContext myCtx;

  void _deleteListItem(StoreItem item) async {
    var i = await Database_Helper.instance.deleteStoreItems(item.id);
    print('Deleted $i');
    setState(() {
      widget._allStoreItems.removeWhere((element) => element.id == item.id);
    });
  }

  void _addShoppingListItem(StoreItem item) {
    
    _insertListItem(ListItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: 'shoppingList',
      name: item.name,
      desc: HueConstants.hueStoreListMsg,
      status: 'none',
    ));
  }

  _insertListItem(newItem) async {
    var itemname = newItem.name;
    int i = await Database_Helper.instance.insertListItems(newItem.toJson());
    print('The new item id: $i');
    Scaffold.of(myCtx).showSnackBar(
                          SnackBar(content: Text("$itemname added to your shopping list")));
  }

  _addToShoppingList(StoreItem item) {
    StoreItem updatedItem = StoreItem(
      id: item.id,
      parentId: item.parentId,
      name: item.name,
      count: item.count,
      addedToList: 'true',
    );
    _updateStoreItem(updatedItem);
    _addShoppingListItem(updatedItem);
  }

  _reduceStoreItemCount(StoreItem item) {
    int itemCount = item.count;
    StoreItem updatedItem;
    String addedToList = item.addedToList;

    if (itemCount != 0) {
      itemCount--;
    }

    if (itemCount == 0) {
      _addShoppingListItem(item);
      addedToList = 'true';
    }
    updatedItem = StoreItem(
      id: item.id,
      parentId: item.parentId,
      name: item.name,
      count: itemCount,
      addedToList: addedToList,
    );
    
    _updateStoreItem(updatedItem);
  }

  _updateStoreItem(StoreItem updatedItem) async {
    int i = await Database_Helper.instance.updateStoreItems(updatedItem.toJson());
    print('Updated: $i');
    widget._readAllItems(updatedItem.parentId);
  }

  Color _getCountColor(count) {
    if (count > 1) {
      return Colors.green[900];
    } else if (count == 1) {
      return Colors.red[900];
    } else {
      return Colors.grey[700];
    }
  }

  @override
  Widget build(BuildContext context) {
    myCtx = context;
    final mediaQueryCtx = MediaQuery.of(context);
    return Container(
      height: (mediaQueryCtx.size.height - mediaQueryCtx.padding.top - 340),
      //height: MediaQuery.of(context).size.height * 0.6,
      child: widget._allStoreItems.isEmpty
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
                    height: 220,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget._allStoreItems.length,
              itemBuilder: (ctx, index) {
                StoreItem storeItem = widget._allStoreItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  elevation: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 50,
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    storeItem.addedToList == 'true' 
                                    ? Icons.playlist_add_check
                                    : Icons.playlist_add,
                                    size: 40,
                                  ),
                                  tooltip: storeItem.addedToList == 'true'
                                      ? 'Added to shopping List'
                                      : 'Add to shopping list',
                                  color: storeItem.addedToList == 'true'
                                      ? Colors.green
                                      : Colors.grey,
                                  onPressed: () {
                                    if (storeItem.addedToList != 'true') {
                                      _addToShoppingList(storeItem);
                                    }
                                  },
                                ),
                                FittedBox(
                                  child: Text(
                                    storeItem.addedToList == 'true'
                                      ? 'Added'
                                      : 'Add to List',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storeItem.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Available: ' + storeItem.count.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: _getCountColor(storeItem.count),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle),
                            color: Theme.of(context).accentColor,
                            iconSize: 28,
                            onPressed: () {
                              _reduceStoreItemCount(storeItem);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue[900],
                            onPressed: () {
                              widget.startUpdateForm(storeItem);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () {
                              _deleteListItem(storeItem);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
