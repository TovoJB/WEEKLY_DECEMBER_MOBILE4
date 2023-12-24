import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  SpeechToText _speech = SpeechToText();
  String _title = '';
  String _content = '';
  String _selectedCategory = 'Vert';

  Future<void> _saveNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notes = prefs.getStringList('notes') ?? [];
    notes.add('$_title\n category $_selectedCategory\n$_content');
    await prefs.setStringList('notes', notes);
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            if (_titleController.text.isEmpty) {
              _title = result.recognizedWords;
              _titleController.text = _title;
            } else {
              _content = result.recognizedWords;
              _contentController.text = _content;
            }
          });
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une note'),
        backgroundColor: Colors.green.shade300,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Contenu',
                ),
              ),
              SizedBox(height: 12.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: ['Rouge', 'Vert', 'Jaune'].map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                  });
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _startListening,
                child: Text('Enregistrer par la voix'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  _title = _titleController.text;
                  _content = _contentController.text;
                  await _saveNote();
                  Navigator.pop(context, true); // Retour à la page précédente
                },
                child: Text('Enregistrer la note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

