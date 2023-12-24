import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalnote/pages/AddNotePage.dart';
import 'package:vocalnote/pages/NoteDetailPage.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<String> _notes = []; // Liste des titres des notes

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Charger les notes au démarrage de la page
  }

void _deleteNote(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _notes.removeAt(index);
    prefs.setStringList('notes', _notes); // Mettre à jour les notes dans SharedPreferences
  });
}

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes') ?? [];
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.green[400],
      centerTitle: true,
      title: const Text('Liste des Notes',),
    ),
    body: Container(
      color: Color.fromARGB(31, 175, 170, 170),
      child: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
        Color borderColor = Colors.green; // Couleur par défaut

    if (_notes[index].contains('Rouge')) {
      borderColor = Colors.red.shade300;
    } else if (_notes[index].contains('Vert')) {
      borderColor = Colors.green.shade300;
    } else if (_notes[index].contains('Jaune')) {
      borderColor = Colors.yellow.shade300;
    }
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5.0 , horizontal: 8.0),
            decoration: BoxDecoration(
              color: borderColor, // Couleur de fond gris pour chaque élément
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(content: _notes[index]),
                        ),
                      );
                    },
                    child: Text(
                      _notes[index].split('\n')[0],
                      style: const TextStyle(
                        //color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete , color: Colors.red,),
                    onPressed: () {
                      _deleteNote(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.green.shade300,
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddNotePage(),
          ),
        );
        if (result == true) {
          _loadNotes();
        }
      },
      child: Icon(Icons.add),
    ),
  );
}
}