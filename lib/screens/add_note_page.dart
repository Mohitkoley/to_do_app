// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/database/database.dart';
import 'package:to_do_app/models/note_model.dart';
import 'package:to_do_app/screens/home_screen.dart';

class AddNotePage extends StatefulWidget {
  final Note? note;
  final Function? updateNoteList;

  AddNotePage({this.note, this.updateNoteList, Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _priority = "Low";
  String _btnText = "Add Note";
  String _titleText = "Add Notes";
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final _priorities = ["High", "Medium", "Low"];
  DateFormat _dateFormatter = DateFormat("dd MMM,yyyy");

  _datePicker() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
    }
    _dateController.text = _dateFormatter.format(date!);
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint("Title: $_title, Priority: $_priority, Date: $_date");

      Note note = Note(title: _title, date: _date, priority: _priority);

      if (widget.note == null) {
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title!;
      _priority = widget.note!.priority!;
      _date = widget.note!.date!;
      setState(() {
        _btnText = "Update Note";
        _titleText = "Update Note";
      });
    } else {
      setState(() {
        _btnText = "Add Note";
        _titleText = "Add Note";
      });
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
  }

  _delete() {
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()));
    widget.updateNoteList!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text("Add Notes"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      _titleText,
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                  labelText: "Title",
                                  labelStyle: TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              validator: (value) => value!.isEmpty
                                  ? "Please enter a note title "
                                  : null,
                              onSaved: (value) => _title = value!,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              style: TextStyle(fontSize: 18.0),
                              onTap: () => _datePicker(),
                              decoration: InputDecoration(
                                  labelText: "Date",
                                  labelStyle: TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: DropdownButtonFormField(
                              isDense: true,
                              icon: Icon(Icons.arrow_drop_down_circle),
                              iconSize: 22.0,
                              elevation: 16,
                              iconEnabledColor: Theme.of(context).primaryColor,
                              value: _priority,
                              onChanged: (value) {
                                setState(() {
                                  _priority = value.toString();
                                });
                              },
                              items: _priorities.map((String priority) {
                                return DropdownMenuItem<String>(
                                  value: priority,
                                  child: Text(priority,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 116, 19, 143))),
                                );
                              }).toList(),
                              dropdownColor: Colors.blue[200],
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  labelText: "Priority",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              validator: (value) => _priority.isEmpty
                                  ? "Please select a priority level"
                                  : null,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0),
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: ElevatedButton(
                                child: Text(_btnText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0)),
                                onPressed: _submit,
                              )),
                          widget.note != null
                              ? Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  height: 60.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: ElevatedButton(
                                      child: Text(
                                        "Delete Note",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: _delete))
                              : SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}
