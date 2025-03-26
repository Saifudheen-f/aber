import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class NoteController {
  ValueNotifier<List<Map<String, dynamic>>> notesNotifier =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // Database reference
  late Database _database;

  // Initialize database
  Future<void> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'newnotes.db');

    _database = await openDatabase(
      path,
      version: 2, // Incremented version number
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            note TEXT,
            created_at TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add new columns if upgrading from version 1 to 2
          await db.execute('''
            ALTER TABLE Notes ADD COLUMN title TEXT;
            ALTER TABLE Notes ADD COLUMN created_at TEXT;
          ''');
        }
      },
    );
  }

  // Load notes from the database
  Future<void> loadNotes() async {
    await initDatabase();

    final List<Map<String, dynamic>> notesData = await _database.query('Notes');
    notesNotifier.value =
        notesData; // Store complete note data (including title and created_at)
  }

  // Save a new note
  Future<void> saveNote(String title, String note,
      {required VoidCallback setState}) async {
    await initDatabase();

    if (note.isEmpty || title.isEmpty) return;

    final createdAt =
        DateTime.now().toIso8601String(); // Automatically set created_at

    await _database.insert(
      'Notes',
      {
        'title': title,
        'note': note,
        'created_at': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await loadNotes(); // Reload notes from the database after insertion
    setState();
  }

  // Update an existing note
  Future<void> updateNote(int index, String newTitle, String newNote) async {
    await initDatabase();

    if (newNote.isEmpty || newTitle.isEmpty) return;

    final noteId = await _getNoteIdByIndex(index);

    if (noteId != null) {
      await _database.update(
        'Notes',
        {
          'title': newTitle,
          'note': newNote,
          'created_at':
              DateTime.now().toIso8601String(), // Update the timestamp as well
        },
        where: 'id = ?',
        whereArgs: [noteId],
      );
      await loadNotes(); // Reload notes after updating
    }
  }

  // Delete a note
  Future<void> deleteNote(int index) async {
    await initDatabase();

    final noteId = await _getNoteIdByIndex(index);

    if (noteId != null) {
      await _database.delete(
        'Notes',
        where: 'id = ?',
        whereArgs: [noteId],
      );
      await loadNotes(); // Reload notes after deleting
    }
  }

  // Helper method to get the note's ID by its index
  Future<int?> _getNoteIdByIndex(int index) async {
    final List<Map<String, dynamic>> notesData = await _database.query('Notes');
    return notesData.length > index ? notesData[index]['id'] as int : null;
  }
}
