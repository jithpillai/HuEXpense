import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ViewNotes extends StatelessWidget {
  final int noteId;
  final String title;
  final String content;
  final Function onSavePressed;

  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  ViewNotes(this.noteId, this.title, this.content, this.onSavePressed) {
    print(this.title);
    _titleController.text = this.title;
    _contentController.text = this.content;
  }

  void _submitNote(context) {
    final newtitle = _titleController.text;
    final newcontent = _contentController.text;

    if (newtitle.isEmpty || newcontent.isEmpty) {
      return;
    }
    onSavePressed(
      noteId,
      newtitle,
      newcontent,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new TextField(
          controller: _titleController,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration.collapsed(
            hintText: "Title",
          ),
        ),
        actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          color: Colors.white,
          onPressed: () {
            String newtitle = _titleController.text;
            String newcontent = _contentController.text;
            String shareContent = '*'+newtitle+'* \n'; //* added for Whatsapp bold text

            shareContent += newcontent; 
            final RenderBox box = context.findRenderObject();
            Share.share(
              shareContent,
              subject:  'Notes: '+newcontent,
              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
            );
          },
        ),],
      ),
      body: new Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Your notes here',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onSubmitted: (_) => {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RaisedButton(
        color: Theme.of(context).accentColor,
        child: Container(
          width: 75,
          child: Row(
            children: [
              Icon(
                Icons.save,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          _submitNote(context);
        },
      ),
    );
  }
}
