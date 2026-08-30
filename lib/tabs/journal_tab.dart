import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal_app/widgets/journal_input.dart';

class JournalTab extends StatelessWidget {
  const JournalTab({super.key});

  void _onSave(String message) async {
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (message.isNotEmpty && uid != null) {
      await db.collection("journal").add({
        "message": message,
        "createdAt": FieldValue.serverTimestamp(),
        "userId": uid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return JournalInput(onSave: _onSave);
  }
}
