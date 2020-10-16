import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NoteForm extends StatefulWidget {
  final Function onSavePressed;

  NoteForm(this.onSavePressed);

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  void _submitNote() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      return;
    }
    widget.onSavePressed(title, content,);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = 'Notes - ${DateFormat.yMMMMd().format(DateTime.now())}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                /* onChanged: (value) {
                        titleInput = value;
                      }, */
              ),
              TextField(
                controller: _contentController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter your notes here',
                ),
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                onSubmitted: (_) => _submitNote(),
                //onChanged: (value) => amountInput = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    child: Text('Save'),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: _submitNote,
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    color: Theme.of(context).errorColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
