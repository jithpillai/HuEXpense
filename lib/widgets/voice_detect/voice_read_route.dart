import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:hueganizer/constants/constants.dart';
import 'package:hueganizer/models/listItem.dart';
import 'package:hueganizer/models/notes.dart';
import 'package:hueganizer/providers/db_helper.dart';
import 'package:hueganizer/utils/hue_utils.dart';
import 'package:hueganizer/widgets/dashboard/hue-dashboard.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceReadRoute extends StatefulWidget {
  static const String routeName = '/voiceread';
  @override
  _VoiceReadRouteState createState() => _VoiceReadRouteState();
}

class _VoiceReadRouteState extends State<VoiceReadRoute> {
  var soundLevel;
  BuildContext vCtx;
  final GlobalKey<ScaffoldState> _voiceMainKey = new GlobalKey<ScaffoldState>();
  RegExp shoppingListExp = new RegExp(
    r"add to shopping list",
    multiLine: true,
    caseSensitive: false,
  );
  RegExp notesExp = new RegExp(
    r"add note",
    multiLine: true,
    caseSensitive: false,
  );
  
  final _contentController = TextEditingController();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    Future.delayed(Duration(milliseconds: 500), () {
      _listen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryCtx = MediaQuery.of(context);
    vCtx = context;

    AppBar appBar = AppBar(
      title: Text('Voice Assist'),
      actions: [
        IconButton(
            tooltip: 'Add to Hue-Notes',
            onPressed: () {
              String content;
              if (_isListening) {
                _listen(); //Stops listening;
              }
              content = _contentController.text;
              _addNotes(content);
              _voiceMainKey.currentState.showSnackBar(SnackBar(
                content: Text('Memo added to Hue-Notes.'),
                duration: Duration(seconds: 3),
              ));
              Navigator.of(context).pop(true);
            },
            color: Colors.white,
            icon: Icon(Icons.note_add),
          ),
          IconButton(
            tooltip: 'Add to Shopping list',
            onPressed: () {
              String content;
              if (_isListening) {
                _listen(); //Stops listening;
              }
              content = _contentController.text;
              _addToShoppingList(content);
            },
            color: Colors.white,
            icon: Icon(Icons.add_shopping_cart),
          ),
          Container(
            child: IconButton(
              icon: Icon(Icons.share),
              color: Colors.white,
              onPressed: () {
                final RenderBox box = context.findRenderObject();
                Share.share(
                  _contentController.text,
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size,
                );
              },
            ),
          ),
      ],
    );
    return Scaffold(
      key: _voiceMainKey,
      appBar: appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: false,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.stop : Icons.mic),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              height: (mediaQueryCtx.size.height -
                      appBar.preferredSize.height) *
                  0.5,
              child: TextField(
                controller: _contentController,
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: HueConstants.voiceAssitInfo,
                ),
                maxLines: 8,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Container(
              height: (mediaQueryCtx.size.height -
                      appBar.preferredSize.height - 50) *
                  0.4,
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  _text,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _addNotes(String content) {
    String title = 'Notes - ${DateFormat.yMMMd().format(DateTime.now())}';

    var note = Notes(
      title: title,
      content: content,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    _insertNotes(note);
  }

  _insertNotes(newNotes) async {
    int i = await Database_Helper.instance.insertNotes(newNotes.toJson());
    print('The new notes id: $i');
    _voiceMainKey.currentState.showSnackBar(SnackBar(
      content: Text('Memo added to Hue-Notes.'),
      duration: Duration(seconds: 3),
    ));
    _resetVoiceDetect();
  }

  _addToShoppingList(String content) {
    _insertShoppingListItem(ListItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: 'shoppingList',
      name: content,
      desc: HueConstants.voiceAssistMsg,
      status: 'none',
    ));
  }

  _insertShoppingListItem(newItem) async {
    int i = await Database_Helper.instance.insertListItems(newItem.toJson());
    print('The new item id: $i');
    _voiceMainKey.currentState.showSnackBar(SnackBar(
      content: Text('${newItem.name} added to shopping list.'),
      duration: Duration(seconds: 3),
    ));
    _resetVoiceDetect();
  }

  _resetVoiceDetect() {
    setState(() {
      _text = '';
      _contentController.text = '';
    });
  }

  _detectCommandFromText() {
    var valueArray;
    if (shoppingListExp.hasMatch(_text)) {
      valueArray = _text.split(shoppingListExp);
      _addToShoppingList(valueArray[1]);
    }
    if (notesExp.hasMatch(_text)) {
      valueArray = _text.split(notesExp);
      _addNotes(valueArray[1]);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('New onStatus: $val');
          if (val == 'notListening') {
            String currentText = _contentController.text;
            _speech.stop();
            _detectCommandFromText();
            setState(() {
              _isListening = false;
              _contentController.text = '$currentText $_text';
            });
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              //_contentController.text = _text;
            });
          },
        );
      }
    } else {
      String currentText = _contentController.text;
      _speech.stop();
      _detectCommandFromText();
      setState(() {
        _isListening = false;
        _contentController.text = '$currentText $_text';
      });
    }
  }
}
