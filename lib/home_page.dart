import 'package:db_exp_450/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var titleController = TextEditingController();
  var descController = TextEditingController();

  DbHelper? dbHelper;
  List<Map<String, dynamic>> mNotes = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.getInstance();
    getAllNotes();
  }

  void getAllNotes() async {
    mNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: mNotes.isNotEmpty
          ? ListView.builder(
              itemCount: mNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(mNotes[index][DbHelper.column_note_title]),
                  subtitle: Text(mNotes[index][DbHelper.column_note_desc]),
                );
              },
            )
          : Center(child: Text('No Notes yet!!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /// add the note
          titleController.clear();
          descController.text = "";
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Container(
                padding: EdgeInsets.all(11),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Enter your title here..",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    TextField(
                      controller: descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Desc",
                        hintText: "Enter your desc here..",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                    SizedBox(height: 11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            bool isAdded = await dbHelper!.addNote(
                              title: titleController.text,
                              desc: descController.text,
                            );

                            if(isAdded){
                              getAllNotes();
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Add'),
                        ),
                        SizedBox(width: 11),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
