import 'package:db_exp_450/add_note_page.dart';
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          titleController.text =
                              mNotes[index][DbHelper.column_note_title];
                          descController.text =
                              mNotes[index][DbHelper.column_note_desc];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return AddNotePage(
                                  isUpdate: true,
                                  id: mNotes[index][DbHelper.column_note_id],
                                  title: mNotes[index][DbHelper.column_note_title],
                                  desc: mNotes[index][DbHelper.column_note_desc],
                                );
                              },
                            ),
                          );

                          /*showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return getMyBottomSheetUI(
                                isUpdate: true,
                                id: mNotes[index][DbHelper.column_note_id],
                              );
                            },
                          );*/
                        },
                        icon: Icon(Icons.edit_note),
                      ),
                      IconButton(
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Container(
                                padding: EdgeInsets.all(11),
                                height: 120,
                                child: Column(
                                  children: [
                                    Text(
                                      'Are you sure you want to delete this note?',
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () async {
                                            bool isDeleted = await dbHelper!
                                                .deleteNote(
                                                  id:
                                                      mNotes[index][DbHelper
                                                          .column_note_id],
                                                );
                                            if (isDeleted) {
                                              getAllNotes();
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text('Yes'),
                                        ),
                                        SizedBox(width: 11),
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: Text('No Notes yet!!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /// add the note
          titleController.clear();
          descController.text = "";

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return AddNotePage();
              },
            ),
          );

          /*showModalBottomSheet(
            context: context,
            builder: (_) {
              return getMyBottomSheetUI();
            },
          );*/
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getMyBottomSheetUI({bool isUpdate = false, int? id}) {
    return Container(
      padding: EdgeInsets.all(11),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            '${isUpdate ? 'Update' : 'Add'} Note',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
                  bool isChanged = false;

                  if (isUpdate) {
                    isChanged = await dbHelper!.updateNote(
                      updTitle: titleController.text,
                      updDesc: descController.text,
                      id: id!,
                    );
                  } else {
                    isChanged = await dbHelper!.addNote(
                      title: titleController.text,
                      desc: descController.text,
                    );
                  }

                  if (isChanged) {
                    getAllNotes();
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
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
  }
}
