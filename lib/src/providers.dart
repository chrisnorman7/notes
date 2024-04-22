import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

/// The key where notes will be stored.
const notesKey = 'site.backstreets.notes.notes';

/// Provide all the notes which have been created.
@riverpod
Future<List<String>> notes(final NotesRef ref) async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getStringList(notesKey) ?? [];
}

/// Save all notes.
Future<void> saveNotes(final WidgetRef ref, final List<String> notes) async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.setStringList(notesKey, notes);
  ref.invalidate(notesProvider);
}
