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
  bool _isSearching = false;

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
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              'My Notes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, size: 24),
                onPressed: () => _handleLogout(context),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _isSearching && _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isSearching = value.isNotEmpty;
                    });
                  },
                ),
              ),
              // Notes list
              Expanded(
                child: StreamBuilder<List<Note>>(
                  stream: notesViewModel.getUserNotes(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final notes = snapshot.data ?? [];
                    
                    // Apply search filter directly in UI
                    final displayNotes = _isSearching && _searchController.text.isNotEmpty
                        ? notes.where((note) =>
                            note.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                            note.content.toLowerCase().contains(_searchController.text.toLowerCase())
                          ).toList()
                        : notes;

                    if (displayNotes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'No notes yet'
                                  : 'No notes found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'Create your first note to get started'
                                  : 'Try a different search term',
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
                      padding: const EdgeInsets.all(16),
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNoteScreen(),
                ),
              );
              if (result == true && mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Note created successfully'),
                    backgroundColor: Color(0xFF10B981),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('New Note'),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
         onTap: () async {
  // ✅ Capture messenger BEFORE any async operation
  final messenger = ScaffoldMessenger.of(context);

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditNoteScreen(note: note),
    ),
  );

  // ✅ Use captured messenger (safe after await)
  if (result == true && mounted) {
    messenger.clearSnackBars();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('✓ Note updated successfully'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }
},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: const [
                                Icon(Icons.delete_outline, size: 20),
                                SizedBox(width: 12),
                                Text('Delete'),
                              ],
                            ),
                            onTap: () {
                              _handleDeleteNote(context, note, notesViewModel);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(note.updatedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Note'),
      content: const Text('Are you sure you want to delete this note?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // ✅ Capture messenger BEFORE any async gap
            final messenger = ScaffoldMessenger.of(context);

            // Close the dialog
            Navigator.pop(dialogContext);

            // Perform delete operation
            final success = await notesViewModel.deleteNote(note.id);

            // ✅ Use captured messenger — no context lookup after async gap
            messenger.clearSnackBars();
            if (success) {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('✓ Note deleted successfully'),
                  backgroundColor: Color(0xFF10B981),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Failed to delete note'),
                  backgroundColor: Color(0xFFEF4444),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Color(0xFFEF4444)),
          ),
        ),
      ],
    ),
  );
}

  void _handleLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);

            // ✅ Capture before await
            final messenger = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(context);

            messenger.clearSnackBars();
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Logging out...'),
                duration: Duration(seconds: 1),
              ),
            );

            await context.read<AuthViewModel>().signOut();

            if (mounted) {
              messenger.clearSnackBars();
              navigator.pushReplacementNamed('/login');
            }
          },
          child: const Text('Logout', style: TextStyle(color: Color(0xFFEF4444))),
        ),
      ],
    ),
  );
}
}