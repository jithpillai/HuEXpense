import 'package:flutter/material.dart';
import 'package:hueganizer/models/notes.dart';
import 'package:hueganizer/providers/db_helper.dart';
import 'package:hueganizer/widgets/app_drawer.dart';
import 'package:hueganizer/widgets/huenotes/note_form.dart';
import 'package:hueganizer/widgets/huenotes/notes_list.dart';

class HueNotesRoute extends StatefulWidget {
  static const String routeName = '/notes';
  @override
  _HueNotesRouteState createState() => _HueNotesRouteState();
}

class _HueNotesRouteState extends State<HueNotesRoute> {
  final List<Notes> _allNotes = [];

  void _deleteNotes(noteId) async {
    var i = await Database_Helper.instance.deleteNotes(noteId);
    print('Deleted $i');
    setState(() {
      _allNotes.removeWhere((element) => element.id == noteId);
    });
  }

  void _startAddNotes(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (bCtx) {
          return NoteForm(_addNotes);
        });
  }

  _addNotes(String title, String content) {
    var note = Notes(
      title: title,
      content: content,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    _insertNotes(note);
  }

  _insertNotes(newNotes) async {
    int i = await Database_Helper.instance.insertNotes(newNotes.toJson());
    print('The new transaction id: $i');
    _readAllNotes();
  }

  _updateNotes(note) async {
    int i = await Database_Helper.instance.updateNotes(note.toJson());
    print('The new transaction id: $i');
    _readAllNotes();
  }

  _readAllNotes() async {
    List<Map<String, dynamic>> queryNotes = await Database_Helper.instance.queryAllNotes();
    List<Notes> allItems = [];

    _allNotes.clear();
    print('All Notes $queryNotes');

    queryNotes.forEach((element) {
      
      allItems.add(Notes(
        id: element['id'],
        title: element['title'],
        content: element['content'],
      ));
    });
    setState(() {
      _allNotes.addAll(allItems);
    });
  }

  @override
  void initState() {
    super.initState();
    _readAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryCtx = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Hue-Notes'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _startAddNotes(context);
          },
        ),
      ],
    );

    return new Scaffold(
      appBar: appBar,
      drawer: AppDrawer(),
      body: NotesList(_allNotes, _deleteNotes, _updateNotes),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNotes(context);
        },
      ),
    );
  }
}
