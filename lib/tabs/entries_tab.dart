import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal_app/models/journal_entry.dart';
import 'package:flutter_journal_app/screens/edit_screen.dart';
import 'package:intl/intl.dart';

class EntriesTab extends StatefulWidget {
  static const _stickyColors = [
    Color.fromARGB(255, 255, 194, 221),
    Color(0xFF7afcff),
    Color(0xFFfeff9c),
  ];

  const EntriesTab({super.key});

  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

class _EntriesTabState extends State<EntriesTab> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  Color _stickyColorFor(String id) {
    final index = id.hashCode.abs() % EntriesTab._stickyColors.length;
    return EntriesTab._stickyColors[index];
  }

  String _createdAtLabel(Timestamp? createdAt) {
    if (createdAt == null) {
      return 'Just now';
    }
    return DateFormat("MMM d, y 'at' h:mm a").format(createdAt.toDate());
  }

  void _deleteEntry(String id) {
    FirebaseFirestore.instance
        .collection(JournalEntry.collection)
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(JournalEntry.collection)
            .where(JournalEntry.fieldUserId, isEqualTo: uid)
            .orderBy(JournalEntry.fieldCreatedAt, descending: true) // newest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final journalEntries =
              snapshot.data?.docs.map(JournalEntry.fromDoc).toList() ?? [];

          return journalEntries.isEmpty
              ? const Center(child: Text("No journal entries found"))
              : ListView(
                  children: journalEntries.map((entry) {
                    return Stack(children: [
                      Card(
                          color: _stickyColorFor(entry.id),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Padding(padding: EdgeInsetsGeometry.only(top: 24, bottom: 16), child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(message: entry.message, id: entry.id,)));
                            },
                            title: Text(entry.message),
                            subtitle: Text(_createdAtLabel(entry.createdAt)),
                          ),)
                      ),
                      Positioned(top: 18, right: 18, child: IconButton(onPressed: () {
                        _deleteEntry(entry.id);
                      }, icon: Icon(Icons.close, size: 18)))
                    ],);
                  }).toList(),
                );
        },
      ),
    );
  }
}
