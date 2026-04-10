import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a 1-to-1 chat room document in Firestore.
///
/// Stored at `chatRooms/{chatRoomId}` where `chatRoomId` is a
/// deterministic sorted concatenation of participant UIDs.
class ChatRoomModel {
  final String id;

  /// Exactly two UIDs — used for Firestore array-contains queries.
  final List<String> participants;

  /// Denormalized display names keyed by UID for instant rendering.
  final Map<String, String> participantNames;

  /// Denormalized profile image URLs keyed by UID.
  final Map<String, String> participantImages;

  final String lastMessage;
  final DateTime? lastMessageTime;
  final String lastMessageSenderId;
  final DateTime createdAt;

  /// Local-only flag — not persisted in Firestore.
  final bool isFavorite;

  const ChatRoomModel({
    required this.id,
    required this.participants,
    required this.participantNames,
    this.participantImages = const {},
    this.lastMessage = '',
    this.lastMessageTime,
    this.lastMessageSenderId = '',
    required this.createdAt,
    this.isFavorite = false,
  });

  // ─── Convenience helpers ──────────────────────────────────────────────────

  /// Returns the other participant's display name.
  String getOtherName(String myUid) {
    final otherUid = participants.firstWhere(
      (uid) => uid != myUid,
      orElse: () => '',
    );
    return participantNames[otherUid] ?? 'مستخدم';
  }

  /// Returns the other participant's profile image URL.
  String getOtherImage(String myUid) {
    final otherUid = participants.firstWhere(
      (uid) => uid != myUid,
      orElse: () => '',
    );
    return participantImages[otherUid] ?? '';
  }

  /// Returns the other participant's UID.
  String getOtherUid(String myUid) {
    return participants.firstWhere(
      (uid) => uid != myUid,
      orElse: () => '',
    );
  }

  // ─── Serialization ────────────────────────────────────────────────────────

  factory ChatRoomModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return ChatRoomModel(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      participantNames: Map<String, String>.from(map['participantNames'] ?? {}),
      participantImages: Map<String, String>.from(map['participantImages'] ?? {}),
      lastMessage: map['lastMessage'] as String? ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp?)?.toDate(),
      lastMessageSenderId: map['lastMessageSenderId'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'participantNames': participantNames,
      'participantImages': participantImages,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : FieldValue.serverTimestamp(),
      'lastMessageSenderId': lastMessageSenderId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ─── copyWith ─────────────────────────────────────────────────────────────

  ChatRoomModel copyWith({
    String? id,
    List<String>? participants,
    Map<String, String>? participantNames,
    Map<String, String>? participantImages,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      participantNames: participantNames ?? this.participantNames,
      participantImages: participantImages ?? this.participantImages,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
