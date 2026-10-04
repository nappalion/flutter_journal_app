import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_journal_app/models/journal_entry.dart';
import 'package:flutter_journal_app/widgets/auth_layout.dart';
import 'package:flutter_journal_app/widgets/emoji_picker.dart';
import 'package:intl/intl.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final User? _user = FirebaseAuth.instance.currentUser;
  late final DocumentReference<Map<String, dynamic>> _userRef;
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _userDoc;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _entries;

  @override
  void initState() {
    super.initState();
    final uid = _user?.uid ?? "guest";
    _userRef = FirebaseFirestore.instance.collection("users").doc(uid);
    _userDoc = _userRef.snapshots();
    _entries = FirebaseFirestore.instance
        .collection(JournalEntry.collection)
        .where(JournalEntry.fieldUserId, isEqualTo: uid)
        .snapshots();
  }

  Future<void> _changeEmoji(String current) async {
    final picked = await showEmojiPicker(context, selected: current);
    if (picked == null || picked == current) return;
    try {
      await _userRef.set({ProfileEmoji.field: picked}, SetOptions(merge: true));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't update your emoji.")),
      );
    }
  }

  static int _wordCount(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;
  }

  static String _accountAge(DateTime? createdAt) {
    if (createdAt == null) return "—";
    final days = DateTime.now().difference(createdAt).inDays;
    if (days < 1) return "Today";
    if (days < 30) return "$days ${days == 1 ? 'day' : 'days'}";
    final months = days ~/ 30;
    if (months < 12) return "$months ${months == 1 ? 'month' : 'months'}";
    final years = days ~/ 365;
    return "$years ${years == 1 ? 'year' : 'years'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDoc,
                builder: (context, snapshot) {
                  final data = snapshot.data?.data() ?? {};
                  final emoji =
                      data[ProfileEmoji.field] as String? ?? ProfileEmoji.fallback;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _EmojiBadge(
                        emoji: emoji,
                        onTap: () => _changeEmoji(emoji),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['username'] as String? ?? 'User',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AuthColors.ink,
                          height: 1.2,
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (_user?.email != null) ...[
                const SizedBox(height: 8),
                Text(
                  _user!.email!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AuthColors.muted,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              _buildStats(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFC62828),
                    side: const BorderSide(color: Color(0xFFE6E1D6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text("Log out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _entries,
      builder: (context, snapshot) {
        final entries =
            snapshot.data?.docs.map(JournalEntry.fromDoc).toList() ?? [];
        final hasData = snapshot.hasData;
        final words = entries.fold<int>(
          0,
          (total, entry) => total + _wordCount(entry.message),
        );
        final number = NumberFormat.decimalPattern();

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E1D6)),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _Stat(
                  value: hasData ? number.format(entries.length) : "—",
                  label: "Entries",
                ),
                const VerticalDivider(color: Color(0xFFE6E1D6), width: 1),
                _Stat(
                  value: _accountAge(_user?.metadata.creationTime),
                  label: "Journaling for",
                ),
                const VerticalDivider(color: Color(0xFFE6E1D6), width: 1),
                _Stat(
                  value: hasData ? number.format(words) : "—",
                  label: "Words",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmojiBadge extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const _EmojiBadge({required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6E1D6)),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 36)),
          ),
          Positioned(
            right: -6,
            bottom: -6,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AuthColors.sage,
                shape: BoxShape.circle,
                border: Border.all(color: AuthColors.paper, width: 2),
              ),
              child: const Icon(Icons.edit, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AuthColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AuthColors.muted),
          ),
        ],
      ),
    );
  }
}
