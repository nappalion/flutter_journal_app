import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late final Future<DocumentSnapshot> _userDoc;

  @override
  void initState() {
    super.initState();
    _userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid ?? "guest")
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // only take up space needed
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: _userDoc,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text("Hello, Guest");
              } else {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                return Text("Hello, ${data['username'] ?? 'User'}");
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
