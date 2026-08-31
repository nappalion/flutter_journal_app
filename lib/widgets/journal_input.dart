
import 'dart:math';

import 'package:flutter/material.dart';

class JournalInput extends StatefulWidget {
  final void Function(String message) onSave;
  final String? initialMessage;
  final String? appBarText;
  final bool isEditing;
  const JournalInput({super.key, required this.onSave, this.initialMessage, this.appBarText, this.isEditing = false});

  @override
  State<JournalInput> createState()  => _JournalInputState();
}

class _JournalInputState extends State<JournalInput> {

  late final TextEditingController _controller;
  late final String _placeholder;
  final List<String> _placeholderEntries = [
    "Today I felt...",
    "I am grateful for...",
    "How was your day?",
  ];
  String _messageText = '';
  String _lastSavedMessage = '';

  @override
  void initState() {
    super.initState();
    final random = Random();
    _placeholder = _placeholderEntries[random.nextInt(_placeholderEntries.length)];
    _controller = TextEditingController(text: widget.initialMessage ?? '');
    _messageText = widget.initialMessage ?? '';
    _lastSavedMessage = widget.initialMessage ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBarText != null
          ? AppBar(title: Text(widget.appBarText!))
          : null,
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
      floatingActionButton: _messageText.isNotEmpty && _messageText != _lastSavedMessage
          ? FloatingActionButton(
        onPressed: () async {
          widget.onSave(_messageText);
            setState(() {
              _lastSavedMessage = _messageText;
              if (!widget.isEditing) {
                _controller.clear();
              _messageText = '';
            }
          });
        },
        child: const Icon(Icons.check),
      )
          : null,
    );
  }
}