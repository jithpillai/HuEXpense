import 'package:flutter/material.dart';

class ListItem {
  String id;
  String parentId;
  String name;
  String desc;
  String status;

  ListItem({
    @required this.id,
    @required this.parentId,
    @required this.name,
    this.desc = "",
    this.status = "none",
  });

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        id: json["id"],
        parentId: json["parentId"],
        name: json["name"],
        desc: json["desc"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parentId": parentId,
        "name": name,
        "desc": desc,
        "status": status,
      };
}

