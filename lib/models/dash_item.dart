import 'package:flutter/material.dart';

class DashItem {
  String id;
  String name;
  String desc;
  String routes;
  Color color;
  IconData icon;

  DashItem({
    @required this.id,
    @required this.name,
    @required this.desc,
    @required this.routes,
    @required this.color,
    @required this.icon,
  });
  
}

