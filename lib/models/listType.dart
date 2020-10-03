import 'package:flutter/material.dart';

class ListType {
  final String id;
  final String name;
  final String desc;

  ListType({
    @required this.id,
    @required this.name,
    this.desc = "User list",
  });

  factory ListType.fromJson(Map<String, dynamic> json) => ListType(
        id: json["id"],
        name: json["name"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
      };
}

