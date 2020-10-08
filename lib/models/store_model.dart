import 'package:flutter/material.dart';

class StoreModel {
  final String id;
  final String name;
  final String desc;

  StoreModel({
    @required this.id,
    @required this.name,
    this.desc = "User Store",
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
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

