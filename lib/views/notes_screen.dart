import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/note_bloc/note_bloc.dart';
import '../controllers/note_bloc/note_event.dart';
import '../controllers/note_bloc/note_state.dart';
import '../models/note_model.dart';
import 'widgets/note_dialog.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  void _showNoteDialog(BuildContext context, {Note? note}) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<NoteBloc>(),
        child: NoteDialog(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes (MVC + BLoC)'),
        centerTitle: true,
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteLoadedState) {
            if (state.notes.isEmpty) {
              return const Center(
                child: Text(
                  'No notes yet.\nTap + to add a new note.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () => _showNoteDialog(context, note: note),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        context.read<NoteBloc>().add(DeleteNoteEvent(note.id));
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
