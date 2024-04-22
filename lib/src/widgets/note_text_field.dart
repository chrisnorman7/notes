import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// A [TextField] for adding a new note.
class NoteTextField extends ConsumerStatefulWidget {
  /// Create an instance.
  const NoteTextField({
    super.key,
  });

  @override
  ConsumerState<NoteTextField> createState() => _NoteTextFieldState();
}

class _NoteTextFieldState extends ConsumerState<NoteTextField> {
  /// The controller to use.
  late final TextEditingController controller;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'New Note'),
        onSubmitted: (final note) async {
          if (note.isNotEmpty) {
            final notes = await ref.read(notesProvider.future);
            await saveNotes(ref, [...notes, note]);
          }
          controller.text = '';
        },
      );
}
