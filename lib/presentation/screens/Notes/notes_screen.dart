import 'package:espoir_marketing/core/dateconvert.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/notes_controller.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/main_button.dart';
import 'package:espoir_marketing/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _noteController;
  late TextEditingController _titleController;
  late NoteController _noteControllerLogic;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _titleController = TextEditingController();
    _noteControllerLogic = NoteController();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await _noteControllerLogic.initDatabase();
    await _noteControllerLogic.loadNotes();
    setState(() {});
  }

  @override
  void dispose() {
    _noteController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _showNoteDialog({required String title, String? note, int? index}) {
    _titleController.text = title;
    _noteController.text = note ?? "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            index == null ? "Add Note" : "Edit Note",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
          //  height:MediaQuery.of(context).size.width,,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextFied(
                  controller: _titleController,
                  hintText: "Enter title...",
                  obscureText: false,
                  maxlength: 50,
                ),
                MyTextFied(
                  controller: _noteController,
                  hintText: "Enter notes...",
                  obscureText: false,
                  maxlength: 200,
                  minLines: 3,
                ),
                MyButton(
                  onpress: () {
                    if (_titleController.text.isEmpty ||
                        _noteController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Title and Note cannot be empty'),
                        ),
                      );
                      return;
                    }

                    if (index == null) {
                      // Add new note
                      _noteControllerLogic.saveNote(
                        _titleController.text,
                        _noteController.text,
                        setState: () {},
                      );
                    } else {
                      // Edit existing note
                      _noteControllerLogic.updateNote(
                        index,
                        _titleController.text,
                        _noteController.text,
                      );
                    }

                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        decoration: imageDecoration,
        child: ValueListenableBuilder(
          valueListenable: _noteControllerLogic.notesNotifier,
          builder: (context, List<Map<String, dynamic>> notes, child) {
            if (notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_alt_outlined,
                        size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "No notes available!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add your first note using the + button.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      onTap: () {
                        _showNoteDialog(
                          title: note['title'],
                          note: note['note'],
                          index: index,
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this note?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _noteControllerLogic.deleteNote(index);
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, gradient: gradient),
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.notes,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        note['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              note['note'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.grey[600], size: 16),
                              const SizedBox(width: 5),
                              Text(
                                localformatDate(note['created_at']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNoteDialog(title: "");
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), gradient: gradient),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
