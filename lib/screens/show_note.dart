
import 'package:flutter/material.dart';
import 'package:notes_lite/db/database_provider.dart';
import 'package:notes_lite/models/note_model.dart';

class ShowNote extends StatelessWidget {
  const ShowNote({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NoteModel note = ModalRoute.of(context)!.settings.arguments as NoteModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              DatabaseProvider.db.deleteNote(note.id!);
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(note.title,
              style:TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Text(
              note.body.toString(),
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}