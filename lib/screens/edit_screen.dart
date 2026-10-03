import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal_app/models/journal_entry.dart';
import 'package:flutter_journal_app/widgets/journal_input.dart';

class EditScreen extends StatelessWidget {
  final String message;
  final String id;
  const EditScreen({super.key, required this.message, required this.id });

  void _onSave(String message) async {
    final db = FirebaseFirestore.instance;
    if (message.isNotEmpty) {
      await db.collection(JournalEntry.collection).doc(id).update(
        JournalEntry.toUpdateMap(message: message),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
   return JournalInput(onSave: _onSave, initialMessage: message, appBarText: "Edit Journal Entry", isEditing: true,);
  }
}
