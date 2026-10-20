import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/note_model.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final List<Note> _notes = [];

  NoteBloc() : super(NoteInitialState()) {
    on<LoadNotesEvent>((event, emit) {
      emit(NoteLoadingState());
      emit(NoteLoadedState(List.from(_notes)));
    });

    on<AddNoteEvent>((event, emit) {
      _notes.insert(0, event.note);
      emit(NoteLoadedState(List.from(_notes)));
    });

    on<UpdateNoteEvent>((event, emit) {
      final index = _notes.indexWhere((note) => note.id == event.note.id);
      if (index != -1) {
        _notes[index] = event.note;
        emit(NoteLoadedState(List.from(_notes)));
      }
    });

    on<DeleteNoteEvent>((event, emit) {
      _notes.removeWhere((note) => note.id == event.id);
      emit(NoteLoadedState(List.from(_notes)));
    });
  }
}
