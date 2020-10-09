import 'package:flutter/material.dart';
import 'package:hueganizer/constants/constants.dart';
import 'package:hueganizer/models/listItem.dart';
import 'package:hueganizer/models/store_item.dart';
import 'package:hueganizer/models/store_model.dart';
import 'package:hueganizer/providers/db_helper.dart';
import 'package:hueganizer/widgets/app_drawer.dart';
import 'package:hueganizer/widgets/huestore/add_store_form.dart';
import 'package:hueganizer/widgets/huestore/store_item_form.dart';
import 'package:hueganizer/widgets/huestore/store_item_list.dart';
import 'package:hueganizer/widgets/huestore/store_slider.dart';
import 'package:share/share.dart';

class HueStoreRoute extends StatefulWidget {
  static const String routeName = '/store';
  @override
  _HueStoreRouteState createState() => _HueStoreRouteState();
}

class _HueStoreRouteState extends State<HueStoreRoute> {
  BuildContext myCtx;
  List<StoreModel> _initStores = [
    StoreModel(id: 'firstStore', name: 'Home'),
    StoreModel(id: 'secondStore', name: 'Kitchen'),
    StoreModel(id: 'thirdStore', name: 'Utilities'),
    StoreModel(id: 'fouthStore', name: 'Store 4'),
    StoreModel(id: 'fifthStore', name: 'Store 5')
  ];
  List<StoreModel> _allStores = [];
  List<StoreItem> _allStoreItems = [];
  String selectedStoreId = 'firstStore';
  String selectedStoreName = '';

  void _doDeleteStore(storeId) async {
    var i = await Database_Helper.instance.deleteStore(storeId);
    print('Deleted $i');
    setState(() {
      _allStores.removeWhere((element) => element.id == storeId);
    });
  }

  _updateStore(StoreModel store) async {
    print(store.toJson());
    int i = await Database_Helper.instance.updateStore(store.toJson());
    print('Updated: $i');
    _readAllStores();
  }

  void onStoreDeletePressed(storeId) async {
    showDialog(
      context: myCtx,
      builder: (ctx) => new AlertDialog(
        title: new Text('Are you sure?'),
        content:
            new Text('All the items added to this store will also be deleted.'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () =>
                Navigator.of(ctx).pop(false), //false will stop the pop
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              _doDeleteStore(storeId);
              Navigator.of(ctx).pop(false);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _addStore(String newName, String newDesc) {
    var store = StoreModel(
        name: newName,
        desc: newDesc,
        id: DateTime.now().millisecondsSinceEpoch.toString());
    _insertStore(store);
  }

  _insertStore(store) async {
    int i = await Database_Helper.instance.insertStore(store.toJson());
    print('The new store id: $i');
    _readAllStores();
  }

  void _startAddStore(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return AddStoreForm(_addStore, true, null);
        });
  }

  void _startUpdateStore(BuildContext ctx, StoreModel store) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return AddStoreForm(_updateStore, true, store);
        });
  }

  _insertDefaultStores() {
    for (var item in _initStores) {
      Database_Helper.instance.insertStore(
          StoreModel(id: item.id, name: item.name, desc: item.desc).toJson());
    }
    Future.delayed(Duration(seconds: 1), () {
      _readAllStores();
    });
  }

  _readAllStores() async {
    List<Map<String, dynamic>> queryStores =
        await Database_Helper.instance.queryAllStores();
    print(queryStores);
    print(queryStores.length);
    if (queryStores.length == 0) {
      _insertDefaultStores();
      return;
    }

    List<StoreModel> allStores = [];

    _allStores.clear();
    print('All Stores $queryStores');

    queryStores.forEach((element) {
      if (selectedStoreName.isEmpty) {
        selectedStoreName = element['name'];
      }
      allStores.add(StoreModel(
        id: element['id'],
        name: element['name'],
        desc: element['desc'],
      ));
    });
    setState(() {
      _allStores.addAll(allStores);
    });
  }

  void _startAddForm(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return StoreItemForm(_addItemToStore, true, null);
        });
  }

  void _startUpdateStoreItem(StoreItem item) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: myCtx,
        builder: (bCtx) {
          return StoreItemForm(_updateStoreItem, true, item);
        });
  }

  void _addItemToStore(String name, int count) {
    _insertListItem(StoreItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: selectedStoreId,
      name: name,
      count: count,
      addedToList: 'false',
    ));
  }

  _insertListItem(StoreItem newItem) async {
    int i = await Database_Helper.instance.insertStoreItems(newItem.toJson());
    print('The new item id: $i');
    _readAllItems(newItem.parentId);
  }

  _readAllItems(storeId) async {
    List<Map<String, dynamic>> queryItems =
        await Database_Helper.instance.queryStoreItems(storeId);
    List<StoreItem> allItems = [];

    _allStoreItems.clear();
    print('All Items $queryItems');

    queryItems.forEach((element) {
      allItems.add(StoreItem(
        id: element['id'],
        parentId: element['parentId'],
        name: element['name'],
        count: element['count'],
        addedToList: element['addedToList'],
      ));
    });
    setState(() {
      _allStoreItems.addAll(allItems);
    });
  }

  _updateStoreItem(StoreItem item) async {
    String addedToList = item.addedToList;
    if (item.count > 0 && addedToList == 'true') {
      _removeFromShoppingList(item);
      addedToList = 'false';
    }
    if (item.count == 0) {
      _addShoppingListItem(item);
      addedToList = 'true';
    }
    item.addedToList = addedToList;
    print(item.toJson());
    int i = await Database_Helper.instance.updateStoreItems(item.toJson());
    print('Updated: $i');
    _readAllItems(item.parentId);
  }

  void _addShoppingListItem(StoreItem item) {
    _insertShoppingListItem(ListItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: 'shoppingList',
      name: item.name,
      desc: HueConstants.hueStoreListMsg,
      status: 'none',
    ));
  }

  _insertShoppingListItem(newItem) async {
    var itemname = newItem.name;
    int i = await Database_Helper.instance.insertListItems(newItem.toJson());
    print('The new item id: $i');
    Scaffold.of(myCtx).showSnackBar(
        SnackBar(content: Text("$itemname added to your shopping list")));
  }

  void _removeFromShoppingList(StoreItem item) async {
    String itemname = item.name;
    int i = await Database_Helper.instance.deleteHueStoreListItems(item);
    print('The deleted item id: $i');
    Scaffold.of(myCtx).showSnackBar(
        SnackBar(content: Text("$itemname removed from shopping list")));
  }

  _refreshStoreItems(StoreModel item) {
    setState(() {
      selectedStoreId = item.id;
      selectedStoreName = item.name;
    });
    _readAllItems(item.id);
  }

  String _getStoreItemsToString() {
    String fullMessage = '*'+selectedStoreName + ' stocks* \n'; //* added for Whatsapp bold text

    for (var item in _allStoreItems) {
      fullMessage += item.name + ': ' + item.count.toString() + ' \n';
    }
    print(fullMessage);
    return fullMessage;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readAllStores();
    _readAllItems(selectedStoreId);
  }

  @override
  Widget build(BuildContext context) {
    myCtx = context;
    final appBar = AppBar(
      title: Text('Hue-Store'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _startAddStore(context);
          },
        ),
      ],
    );
    return new Scaffold(
        appBar: appBar,
        drawer: AppDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: RaisedButton(
          color: Theme.of(context).primaryColorDark,
          child: Container(
            width: 100,
            child: Row(
              children: [
                Icon(
                  Icons.library_add,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
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
        body: Column(
          children: [
            _allStores.isEmpty
                ? Container(
                    margin: EdgeInsets.all(30),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No stores added yet!',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 100,
                          child: Image.asset(
                            'assets/images/waiting.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  )
                : StoreSlider(_allStores, onStoreDeletePressed,
                    (StoreModel store) {
                    _startUpdateStore(myCtx, store);
                  }, _refreshStoreItems),
            //Store Item Header
            Container(
              padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedStoreName,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.white,
                      onPressed: () {
                        final RenderBox box = context.findRenderObject();
                        Share.share(
                          _getStoreItemsToString(),
                          subject: 'Inventory Stock: ' + selectedStoreName,
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                    ),
                  ),
                ],
              ),
              width: double.infinity,
              height: 50,
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
            StoreItemList(selectedStoreId, selectedStoreName, _allStoreItems,
                _startUpdateStoreItem, _readAllItems)
          ],
        ));
  }
}
