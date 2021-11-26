import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_lite/db/database_provider.dart';
import 'package:notes_lite/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final Function changeTheme;
  bool isDark;
  Home({Key? key,required this.changeTheme,this.isDark = false}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getNotes() async {
    final notes = await DatabaseProvider.db.getAllNotes();
    return notes;
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes Lite"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, AsyncSnapshot noteData) {
          switch(noteData.connectionState){
            case ConnectionState.waiting:
            {
              return Center(child: CircularProgressIndicator());
            }
            case ConnectionState.done:
            {
              if(noteData.hasError){
                return Center(child: Text("Error"));
              }
              else{
                if(noteData.data.isEmpty || noteData.data == null || noteData.data.length == 0){
                  return Center(child: Text("No Notes"));
                }
                else{
                  return Padding(padding: EdgeInsets.all(8),
                  child:ListView.builder(
                  itemCount: noteData.data!.length,
                  itemBuilder: (context, index) {
                    NoteModel data = noteData.data![index];
                    String title = data.title;
                    String? body = data.body;
                    String createdAt = data.createdAt;
                    int id = data.id!;
                    return 
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(8),
                          child: ListTile(
                            onTap: (){
                              Navigator.pushNamed(context, '/form-note', arguments: data);
                            },
                            title: Text(title,style:TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(body.toString()),
                          ),),
                          Padding(padding: EdgeInsets.all(8),child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 18,bottom:8),
                              child: Text(createdAt.toString(),style: TextStyle(fontSize: 10),),)
                            ],
                          ),),
                        ],
                      ),
                    );
                    
                  }));
                }
              }
            }
            
            case ConnectionState.none:
              return Center(child: Text("Tidak Ada Data"));
              break;
            case ConnectionState.active:
              return Center(child: Text(""));
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/form-note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.note_add),
      ),
      drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(child: Padding(padding: EdgeInsets.all(10),child: Text('Notes Lite',style: TextStyle(fontSize: 20,color: Colors.white),),),),
              ),
              Padding(padding: EdgeInsets.all(16)
              ,child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.dark_mode,color: Colors.grey,),
                  // Text('Dark Mode'),
                  Padding(padding: EdgeInsets.only(left: 20),child: CupertinoSwitch(
                    activeColor: Colors.blue,
                    value: widget.isDark,
                    onChanged: (v) {
                      setState(() {
                        widget.isDark = !widget.isDark;
                        widget.changeTheme();
                      });
                    },
                  ),)
              ],),),
              ListTile(
                leading: Icon(Icons.delete,color: Colors.grey,),
                title: Text('Delete All Notes'),
                onTap: () {
                  
                  // set up the buttons
                  Widget cancelButton = FlatButton(
                    child: Text("Cancel"),
                    onPressed:  () {
                      Navigator.of(context).pop();
                    },
                  );
                  Widget continueButton = FlatButton(
                    child: Text("Delete All"),
                    onPressed:  () {
                      DatabaseProvider.db.deleteAllNotes();
                      final snackBar = SnackBar(content: Text('All Notes Deleted!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                    },
                  );
                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("Warning"),
                    content: Text("Would you like to delete all notes?"),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );
                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
              ),
             
            ],
          ),
        ),
    );
  }
}
