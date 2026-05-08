import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new note
  Future<Note> createNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    try {
      final docRef = _firestore.collection('notes').doc();
      final now = DateTime.now();

      final note = Note(
        id: docRef.id,
        userId: userId,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(note.toMap());
      return note;
    } catch (e) {
      throw 'Failed to create note: $e';
    }
  }

  // Get all notes for a user
  Stream<List<Note>> getUserNotes(String userId) {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get a single note by ID
  Future<Note?> getNoteById(String noteId) async {
    try {
      final docSnapshot = await _firestore.collection('notes').doc(noteId).get();
      if (!docSnapshot.exists) return null;

      return Note.fromMap(docSnapshot.data()!, noteId);
    } catch (e) {
      throw 'Failed to fetch note: $e';
    }
  }

  // Update a note
  Future<Note> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    try {
      final docSnapshot = await _firestore.collection('notes').doc(noteId).get();
      if (!docSnapshot.exists) {
        throw 'Note not found';
      }

      final data = docSnapshot.data()!;
      final updatedNote = Note(
        id: noteId,
        userId: data['userId'],
        title: title,
        content: content,
        createdAt: DateTime.parse(data['createdAt']),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('notes').doc(noteId).update(updatedNote.toMap());
      return updatedNote;
    } catch (e) {
      throw 'Failed to update note: $e';
    }
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      throw 'Failed to delete note: $e';
    }
  }

  // Search notes by title
  Future<List<Note>> searchNotes({
    required String userId,
    required String query,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .get();

      final notes = snapshot.docs
          .map((doc) => Note.fromMap(doc.data(), doc.id))
          .toList();

      // Client-side search
      return notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw 'Failed to search notes: $e';
    }
  }
}
