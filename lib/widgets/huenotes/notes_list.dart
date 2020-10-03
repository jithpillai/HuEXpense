import 'package:flutter/material.dart';
import 'package:hueganizer/models/notes.dart';
import 'package:hueganizer/models/notes.dart';
import 'package:hueganizer/widgets/huenotes/view_notes.dart';

class NotesList extends StatelessWidget {
  final List<Notes> _allNotes;
  final Function onDeletePressed;
  final Function doUpdateNotes;

  NotesList(this._allNotes, this.onDeletePressed, this.doUpdateNotes);

  _updateNotes(id, title, content) {
    doUpdateNotes(new Notes(id: id, title: title, content: content));
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.6,
      child: _allNotes.isEmpty
          ? Container(
              margin: EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No notes added yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 250,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _allNotes.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new ViewNotes(_allNotes[index].id, _allNotes[index].title, _allNotes[index].content, _updateNotes),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    elevation: 6,
                    child: ListTile(
                      leading: Icon(Icons.note),
                      title: Text(
                        _allNotes[index].title,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _allNotes[index].content,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          onDeletePressed(_allNotes[index].id);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
