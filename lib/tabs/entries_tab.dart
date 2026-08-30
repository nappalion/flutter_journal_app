import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Color _randomStickyColor() {
    final random = Random();
    return EntriesTab._stickyColors[random.nextInt(
      EntriesTab._stickyColors.length,
    )];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("journal")
            .where("userId", isEqualTo: uid)
            .orderBy("createdAt", descending: true) // newest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final journalEntries =
              snapshot.data?.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {...data, "id": doc.id};
              }).toList() ??
                  [];

          return journalEntries.isEmpty
              ? const Center(child: Text("No journal entries found"))
              : ListView(
                  children: journalEntries.map((entry) {
                    final id = entry["id"];
                    final message = entry["message"] ?? "";
                    final createdAt = entry["createdAt"] ?? Timestamp.now();
                    return Card(
                      color: _randomStickyColor(),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(message: message, id: id,)));
                        },
                        title: Text(message),
                        subtitle: Text(
                          DateFormat("MMM d, y 'at' h:mm a")
                              .format(createdAt.toDate()),
                        ),
                      ),
                    );
                  }).toList(),
                );
        },
      ),
    );
  }
}
