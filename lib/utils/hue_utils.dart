import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hueganizer/models/notes.dart';
import 'package:hueganizer/providers/db_helper.dart';
import 'package:intl/intl.dart';

class HueUtils {
  
  HueUtils._privateConstructor();

  static final HueUtils instance = HueUtils._privateConstructor();
 
  static void _addNotes (String content) {
    String title = 'Notes - ${DateFormat.yMMMd().format(DateTime.now())}';
    var note = Notes(
      title: title,
      content: content,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    _insertNotes(note);
  }

  static _insertNotes (newNotes) async {
    int i = await Database_Helper.instance.insertNotes(newNotes.toJson());
    print('The new notes id: $i');
  }
}
