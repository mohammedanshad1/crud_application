import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/notes_viewmodel.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

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
        title: const Text('Create Note'),
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
                          onPressed: _handleSaveNote,
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

  Future<void> _handleSaveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final notesViewModel = context.read<NotesViewModel>();
    final userId = authViewModel.user?.uid ?? '';

    final success = await notesViewModel.createNote(
      userId: userId,
      title: title,
      content: content,
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }
}
