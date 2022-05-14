import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/database/database.dart';
import 'package:to_do_app/models/note_model.dart';
import 'package:to_do_app/screens/add_note_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  late Future<List<Note>> _noteList;
  final DateFormat _dateFormatter = DateFormat("dd MMM, yyyy");

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = DatabaseHelper.instance.getNoteList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: FutureBuilder(
            future: _noteList,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final List<Note> noteCount = snapshot.data! as List<Note>;
              int completedNoteCount = noteCount
                  .where((Note note) => note.status == 1)
                  .toList()
                  .length;
              return ListView.builder(
                itemCount: int.parse(noteCount.length.toString()),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("My Notes",
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.0)),
                            const SizedBox(height: 10),
                            const Text("0 of 10",
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 40.0)),
                          ],
                        ));
                  }
                  return _buildNote(noteCount[index - 1]);
                },
                padding: const EdgeInsets.symmetric(vertical: 80.00),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddNotePage(
                        updateNoteList: _updateNoteList(),
                      )));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildNote(Note note) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Note ${note.title}",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    decoration: note.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              subtitle: Text(
                "${_dateFormatter.format(note.date!)} - ${note.priority}",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              trailing: Checkbox(
                onChanged: (value) {
                  note.status = value! ? 1 : 0;
                  _databaseHelper.updateNote(note);
                  _updateNoteList();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                value: note.status == 1 ? true : false,
                checkColor: Colors.black,
                activeColor: Theme.of(context).primaryColor,
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddNotePage(
                          updateNoteList: _updateNoteList(), note: note))),
            ),
            const Divider(
              height: 5,
              color: Colors.deepPurple,
              thickness: 2.0,
            )
          ],
        ));
  }
}
