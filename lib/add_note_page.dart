import 'package:flutter/material.dart';

import 'db_helper.dart';

class AddNotePage extends StatefulWidget {
  bool isUpdate;
  int? id;
  String title, desc;

  AddNotePage({
    this.isUpdate = false,
    this.id,
    this.title ="",
    this.desc = ""
});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  var titleController = TextEditingController();

  var descController = TextEditingController();

  DbHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper.getInstance();
  }

  @override
  Widget build(BuildContext context) {

    titleController.text = widget.title;
    titleController.text = widget.desc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Container(
        padding: EdgeInsets.all(11),
        width: double.infinity,
        child: Column(
          children: [
            /*Text(
              '${isUpdate ? 'Update' : 'Add'} Note',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),*/
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

                    if(widget.isUpdate){
                      isChanged = await dbHelper!.updateNote(
                        updTitle: titleController.text,
                        updDesc: descController.text,
                        id: widget.id!,
                      );
                    } else {
                      isChanged = await dbHelper!.addNote(
                        title: titleController.text,
                        desc: descController.text,
                      );
                    }

                    if (isChanged) {
                      //getAllNotes();
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
      ),
    );
  }
}
