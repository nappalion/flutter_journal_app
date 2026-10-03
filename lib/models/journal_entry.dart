import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  static const collection = 'journal';
  static const fieldMessage = 'message';
  static const fieldUserId = 'userId';
  static const fieldCreatedAt = 'createdAt';
  static const fieldUpdatedAt = 'updatedAt';

  final String id;
  final String message;
  final String? userId;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const JournalEntry({
    required this.id,
    required this.message,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory JournalEntry.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return JournalEntry(
      id: doc.id,
      message: data[fieldMessage] as String? ?? '',
      userId: data[fieldUserId] as String?,
      createdAt: data[fieldCreatedAt] as Timestamp?,
      updatedAt: data[fieldUpdatedAt] as Timestamp?,
    );
  }

  static Map<String, dynamic> toCreateMap({
    required String message,
    required String userId,
  }) {
    return {
      fieldMessage: message,
      fieldUserId: userId,
      fieldCreatedAt: FieldValue.serverTimestamp(),
    };
  }

  static Map<String, dynamic> toUpdateMap({required String message}) {
    return {
      fieldMessage: message,
      fieldUpdatedAt: FieldValue.serverTimestamp(),
    };
  }
}
