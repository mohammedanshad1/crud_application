import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/notes_service.dart';

class NotesViewModel extends ChangeNotifier {
  final NotesService _notesService = NotesService();

  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Note> get notes => _filteredNotes.isEmpty && _searchQuery.isEmpty
      ? _notes
      : _filteredNotes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // Get notes stream for a user
  Stream<List<Note>> getUserNotes(String userId) {
    return _notesService.getUserNotes(userId);
  }

  // Create a new note
  Future<bool> createNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _notesService.createNote(
        userId: userId,
        title: title,
        content: content,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update a note
  Future<bool> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _notesService.updateNote(
        noteId: noteId,
        title: title,
        content: content,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete a note
  Future<bool> deleteNote(String noteId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _notesService.deleteNote(noteId);
      _notes.removeWhere((note) => note.id == noteId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Search notes
  Future<void> searchNotes({
    required String userId,
    required String query,
  }) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _filteredNotes = [];
      } else {
        _filteredNotes = await _notesService.searchNotes(
          userId: userId,
          query: query,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredNotes = [];
    notifyListeners();
  }

  // Update notes list from stream
  void updateNotes(List<Note> notes) {
    _notes = notes;
    if (_searchQuery.isEmpty) {
      _filteredNotes = [];
    }
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
