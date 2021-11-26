import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_lite/db/database_provider.dart';
import 'package:notes_lite/models/note_model.dart';

class FormNote extends StatefulWidget {
  const FormNote({ Key? key }) : super(key: key);

  @override
  _FormNoteState createState() => _FormNoteState();
}

class _FormNoteState extends State<FormNote> {

  String? title;
  String? body;
  DateTime? createdAt;

  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();


  FormNote(NoteModel) {
    DatabaseProvider.db.addNewNote(NoteModel);
    print("Add Success");
  }

  updateNote(NoteModel) {
    DatabaseProvider.db.updateNote(NoteModel);
    print("Update Success");
  }
  

  @override
  Widget build(BuildContext context) {
    final NoteModel? curNote = ModalRoute.of(context)!.settings.arguments as NoteModel?;
    if(curNote != null) {
      setState(() {
        titleController.text = curNote.title;
        bodyController.text = curNote.body!;
      });
      
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Note'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          (curNote != null)?
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              DatabaseProvider.db.deleteNote(curNote.id!);
              final snackBar = SnackBar(content: Text('Note Deleted!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
          ):Text("")
        ],
      ),
      body:Padding(padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      child: Column(children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
             border: InputBorder.none,
            hintText: 'Note Title',
          ),
          style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextField(
            controller: bodyController,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Notes...',
            ),
          ),
        ),
      ],),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
            createdAt = DateTime.now();

            if(title != null && body != null && title != "" && body != ""){
             
              if(curNote != null){
                NoteModel note = NoteModel(id: curNote.id,title: title!,body: body,createdAt: dateFormat.format(createdAt!));
                updateNote(note);
              } else {
                NoteModel note = NoteModel(title: title!,body: body,createdAt: dateFormat.format(createdAt!));
                FormNote(note);
              }
              final snackBar = SnackBar(content: Text('Note Saved!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            } else {
              print("Please Insert Some Note");
            }
          });
          
        },
        icon: Icon(Icons.save),
        label: Text('Save Note'),
      ),
    );
  }
}
