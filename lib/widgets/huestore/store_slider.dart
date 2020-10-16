import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hueganizer/models/store_model.dart';

class StoreSlider extends StatefulWidget {
  final List<StoreModel> _allStores;
  final Function onDeletePressed;
  final Function startUpdateStore;
  final Function onStoreItemClick;

  StoreSlider(this._allStores, this.onDeletePressed, this.startUpdateStore, this.onStoreItemClick,);

  @override
  _StoreSliderState createState() => _StoreSliderState();
}

class _StoreSliderState extends State<StoreSlider> {
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
  List <Color> builtColors = [];
  List<String> _nonDeletables = ['firstStore', 'secondStore', 'thirdStore'];
  Color getRandomColor(index) {
    int newColor = Random().nextInt(availableColors.length);
    //return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    if (builtColors.length >= index + 1) {
      return builtColors[index];
    }
    builtColors.add(availableColors[newColor]);
    return availableColors[newColor];
  }

  @override
  Widget build(BuildContext context) {
    List<StoreModel> allStores = widget._allStores;
    return Container(
      height: 170,
      //height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allStores.length,
              itemBuilder: (ctx, index) {
                var color = getRandomColor(index);
                var item = allStores[index];
                return GestureDetector(
                  onTap: () {
                    widget.onStoreItemClick(item);
                    //print(allStores[index].name);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    height: 150,
                    width: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.7),
                          color,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            item.desc,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                 widget.startUpdateStore(item);
                                },
                              ),
                            _nonDeletables.contains(item.id)
                            ? SizedBox()
                            : IconButton(
                                icon: Icon(Icons.delete_outline),
                                onPressed: () {
                                 widget.onDeletePressed(item.id);
                                },
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
