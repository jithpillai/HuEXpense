import 'package:flutter/material.dart';

class StoreItem {
  String id;
  String parentId;
  String name;
  int count;
  String addedToList;

  StoreItem({
    @required this.id,
    @required this.parentId,
    @required this.name,
    @required this.count,
    this.addedToList = 'false',
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) => StoreItem(
        id: json["id"],
        parentId: json["parentId"],
        name: json["name"],
        count: json["count"],
        addedToList: json["addedToList"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parentId": parentId,
        "name": name,
        "count": count,
        "addedToList": addedToList,
      };
}

