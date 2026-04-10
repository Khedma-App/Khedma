import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single message inside a chat room.
///
/// Stored at `chatRooms/{chatRoomId}/messages/{messageId}`.
class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  /// Whether this message was sent by the given [uid].
  bool isMine(String uid) => senderId == uid;

  // ─── Serialization ────────────────────────────────────────────────────────

  factory MessageModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': isRead,
    };
  }
}
