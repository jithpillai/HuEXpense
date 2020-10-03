import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hueganizer/models/listType.dart';
import 'package:hueganizer/widgets/huelist/list_type_item.dart';

class ListGridView extends StatefulWidget {
  final List<ListType> _allTypes;
  final Function onDeletePressed;

  ListGridView(this._allTypes, this.onDeletePressed);

  @override
  _ListGridViewState createState() => _ListGridViewState();
}

class _ListGridViewState extends State<ListGridView> {
  final availableColors = [
      Colors.red,
      Colors.amber,
      Colors.blue,
      Colors.cyan,
      Colors.deepOrange,
      Colors.purple,
      Colors.green,
      Colors.blueGrey,
    ];

  Color getRandomColor () {
    return availableColors[Random().nextInt(availableColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(25),
      children: widget._allTypes
          .map((item) => ListTypeItem(
                id: item.id,
                name: item.name,
                desc: item.desc,
                color: getRandomColor(),
                onDeletePressed: widget.onDeletePressed,
              ))
          .toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
