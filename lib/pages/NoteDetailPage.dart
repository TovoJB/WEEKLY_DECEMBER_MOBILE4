import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NoteDetailPage extends StatelessWidget {
  final String content;
  late final String title;
  final FlutterTts flutterTts = FlutterTts();

  NoteDetailPage({Key? key, required this.content}) : super(key: key) {
    // Récupérer le titre à partir du contenu
    title = content.split('\n')[0];
  }

  Future<void> speak() async {
    await flutterTts.setLanguage("fr-FR"); // Choisir la langue souhaitée
    await flutterTts.setPitch(1); // Modifier la tonalité si nécessaire
    await flutterTts.setSpeechRate(1);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             // Modifier la vitesse si nécessaire
    await flutterTts.speak(content); // Lire le contenu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text(title), // Afficher uniquement le titre dans l'appBar
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: speak, // Déclencher la lecture du contenu
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Exclure le titre pour afficher uniquement le contenu
              Text(
                content.substring(title.length + 1),
                 // Afficher le contenu sans le titre
                 style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
