import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/note_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/notes_viewmodel.dart';
import 'create_note_screen.dart';
import 'edit_note_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, NotesViewModel>(
      builder: (context, authViewModel, notesViewModel, _) {
        final userId = authViewModel.user?.uid ?? '';

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Notes'),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _handleLogout,
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              notesViewModel.clearSearch();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      notesViewModel.clearSearch();
                    } else {
                      notesViewModel.searchNotes(
                        userId: userId,
                        query: value,
                      );
                    }
                    setState(() {});
                  },
                ),
              ),

              // Notes list
              Expanded(
                child: StreamBuilder<List<Note>>(
                  stream: notesViewModel.getUserNotes(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final notes = snapshot.data ?? [];
                    notesViewModel.updateNotes(notes);

                    final displayNotes = notesViewModel.notes;

                    if (displayNotes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No notes yet'
                                  : 'No notes found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (_searchController.text.isEmpty)
                              const SizedBox(height: 16),
                            if (_searchController.text.isEmpty)
                              Text(
                                'Create your first note to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: displayNotes.length,
                      itemBuilder: (context, index) {
                        return _buildNoteCard(
                          context,
                          displayNotes[index],
                          notesViewModel,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNoteScreen(),
                ),
              );
              if (result == true && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note created successfully')),
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildNoteCard(
    BuildContext context,
    Note note,
    NotesViewModel notesViewModel,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(note: note),
            ),
          );
          if (result == true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note updated successfully')),
            );
          }
        },
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM dd, yyyy HH:mm').format(note.updatedAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Delete'),
              onTap: () {
                _handleDeleteNote(context, note, notesViewModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleDeleteNote(
    BuildContext context,
    Note note,
    NotesViewModel notesViewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await notesViewModel.deleteNote(note.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted successfully')),
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete note')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthViewModel>().signOut();
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
