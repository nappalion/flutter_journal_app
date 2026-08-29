import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key});

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _placeholderEntries = [
    "Today I felt...",
    "I am grateful for...",
    "How was your day?",
  ];
  late final String _placeholder;
  final db = FirebaseFirestore.instance;
  String _messageText = '';
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _placeholder =
        _placeholderEntries[random.nextInt(_placeholderEntries.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            autofocus: true,
            expands: true,
            maxLines: null,
            minLines: null,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: _placeholder,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: (value) {
              setState(() {
                _messageText = value;
              });
            },
          ),
        ),
      ),
      floatingActionButton: _messageText.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                if (_messageText.isNotEmpty && uid != null) {
                  await db.collection("journal").add({
                    "message": _messageText,
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": uid,
                  });
                  _controller.clear();
                  setState(() {
                    _messageText = '';
                  });
                }
              },
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
