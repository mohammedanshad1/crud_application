import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/note_model.dart';
import '../../viewmodels/notes_viewmodel.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({
    super.key,
    required this.note,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Consumer<NotesViewModel>(
                builder: (context, notesViewModel, _) {
                  return notesViewModel.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : TextButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                          onPressed: _handleUpdateNote,
                        );
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, notesViewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error message
                if (notesViewModel.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      border: Border.all(color: Colors.red.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notesViewModel.errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Title field
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Note title',
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  enabled: !notesViewModel.isLoading,
                  maxLines: null,
                ),
                const SizedBox(height: 16),

                // Metadata
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Created: ${DateFormat('MMM dd, yyyy HH:mm').format(widget.note.createdAt)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.update, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Updated: ${DateFormat('MMM dd, yyyy HH:mm').format(widget.note.updatedAt)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),

                // Content field
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Start typing...',
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  enabled: !notesViewModel.isLoading,
                  maxLines: null,
                  minLines: 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleUpdateNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Check if there are any changes
    if (title == widget.note.title && content == widget.note.content) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes made')),
      );
      return;
    }

    final notesViewModel = context.read<NotesViewModel>();
    final success = await notesViewModel.updateNote(
      noteId: widget.note.id,
      title: title,
      content: content,
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }
}
