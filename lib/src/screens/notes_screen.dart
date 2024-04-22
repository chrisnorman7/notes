import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../widgets/note_text_field.dart';

/// The notes screen.
class NotesScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const NotesScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  NotesScreenState createState() => NotesScreenState();
}

/// State for [NotesScreen].
class NotesScreenState extends ConsumerState<NotesScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final value = ref.watch(notesProvider);
    return SimpleScaffold(
      title: 'Notes',
      body: Column(
        children: [
          Expanded(
            child: value.when(
              data: (final notes) {
                if (notes.isEmpty) {
                  return const CenterText(
                    text: 'There are no notes to show.',
                    autofocus: true,
                  );
                }
                return ListView.builder(
                  itemBuilder: (final context, final index) {
                    final note = notes[index];
                    return CommonShortcuts(
                      deleteCallback: () => deleteNote(ref, index),
                      child: ListTile(
                        title: Text(note),
                        onTap: () => context.pushWidgetBuilder(
                          (final context) => GetText(
                            onDone: (final newNote) async {
                              Navigator.pop(context);
                              notes[index] = newNote;
                              await saveNotes(ref, notes);
                            },
                            actions: [
                              ElevatedButton(
                                onPressed: () => setClipboardText(note),
                                child: const Icon(
                                  Icons.copy_outlined,
                                  semanticLabel: 'Copy Note',
                                ),
                              ),
                            ],
                            labelText: 'Note',
                            text: note,
                            title: 'Edit Note',
                          ),
                        ),
                        onLongPress: () => deleteNote(ref, index),
                      ),
                    );
                  },
                  itemCount: notes.length,
                  shrinkWrap: true,
                );
              },
              error: ErrorListView.withPositional,
              loading: LoadingWidget.new,
            ),
          ),
          const Divider(),
          const NoteTextField(),
        ],
      ),
    );
  }

  /// Delete the note at [index].
  Future<void> deleteNote(final WidgetRef ref, final int index) async {
    final notes = await ref.read(notesProvider.future);
    notes.removeAt(index);
    await saveNotes(ref, notes);
  }
}
