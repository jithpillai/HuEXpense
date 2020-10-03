import 'package:flutter/material.dart';
import 'dart:convert';

List<Notes> txFromJson(String str) =>
    List<Notes>.from(json.decode(str).map((x) => Notes.fromJson(x)));

String txToJson(List<Notes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Notes {
  final int id;
  final String title;
  final String content;

  Notes({
    @required this.id,
    @required this.title,
    @required this.content,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        id: json["id"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
      };
}

