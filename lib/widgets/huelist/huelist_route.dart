import 'package:flutter/material.dart';
import 'package:hueganizer/providers/db_helper.dart';
import 'package:hueganizer/models/listType.dart';
import 'package:hueganizer/widgets/app_drawer.dart';
import 'package:hueganizer/widgets/huelist/add_list_type.dart';
import 'package:hueganizer/widgets/huelist/list_gridview.dart';

class HueListRoute extends StatefulWidget {
  static const String routeName = '/list';
  @override
  _HueListRouteState createState() => _HueListRouteState();
}

class _HueListRouteState extends State<HueListRoute> {
  final _listTypes = [
    ListType(
        id: 'shoppingList', name: 'Shopping List', desc: "Basic shopping list"),
    ListType(id: 'personal', name: 'Personal', desc: "Add anything personal"),
    ListType(id: 'work', name: 'Work', desc: "A work related list"),
    ListType(
        id: 'bucketList',
        name: 'Bucket List',
        desc: "A bucket list for all your dreams"),
    ListType(id: 'ideas', name: 'Ideas', desc: "A list for all your ideas"),
    ListType(
        id: 'movieList',
        name: 'Movie List',
        desc: "All your favorite movies to watch"),
  ];
  final List<ListType> _allListTypes = [];

  _readAllListTypes() async {
    List<Map<String, dynamic>> queryListTypes = await Database_Helper.instance.queryAllListTypes();
    print(queryListTypes);
    print(queryListTypes.length);
    if(queryListTypes.length == 0) {
      _insertDefaultListTypes();
      return;
    }

    List<ListType> allItems = [];

    _allListTypes.clear();
    print('All List Types $queryListTypes');

    queryListTypes.forEach((element) {
      
      allItems.add(ListType(
        id: element['id'],
        name: element['name'],
        desc: element['desc'],
      ));
    });
    setState(() {
      _allListTypes.addAll(allItems);
    });
  }

  _addListType(String newName, String newDesc) {
    var type = ListType(
      name: newName,
      desc: newDesc,
      id: DateTime.now().millisecondsSinceEpoch.toString()
    );
    _insertListType(type);
  }

  _insertListType(listType) async {
    int i = await Database_Helper.instance.insertListTypes(listType.toJson());
    print('The new list id: $i');
    _readAllListTypes();
  }

  void _startAddForm(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return AddListType(_addListType);
        });
  }

  _insertDefaultListTypes() {
    print('Helllllooooo');
    for (var item in _listTypes) {
      print('Inside....');
      Database_Helper.instance.insertListTypes(ListType(id: item.id, name: item.name, desc: item.desc).toJson());
    }
    Future.delayed(Duration(seconds: 2), () {
      _readAllListTypes();
    });
  }

  void _deleteListType(listId) async {
    var i = await Database_Helper.instance.deleteListTypes(listId);
    print('Deleted $i');
    setState(() {
      _allListTypes.removeWhere((element) => element.id == listId);
    });
  }

  @override
  void initState() {
    super.initState();
    _readAllListTypes();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Hue-List'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _startAddForm(context);
          },
        ),
      ],
    );

    return new Scaffold(
      appBar: appBar,
      drawer: AppDrawer(),
      body: ListGridView(_allListTypes, _deleteListType),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RaisedButton(
        color: Theme.of(context).primaryColorDark,
        child: Container(
          width: 90,
          child: Row(
            children: [
              Icon(
                Icons.add_to_queue,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Add List",
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
}
