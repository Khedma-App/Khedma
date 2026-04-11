import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single message inside a chat room.
///
/// Stored at `chatRooms/{chatRoomId}/messages/{messageId}`.
///
/// Supports multiple message types:
/// - `'text'` — standard chat message
/// - `'service_request'` — initial booking request from client
/// - `'modification'` — modification request from either party
/// - `'status_update'` — system message (e.g., "تم قبول طلبك")
class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  /// The type of this message. Defaults to `'text'` for backwards compatibility.
  final String messageType;

  /// Structured payload for service requests and modifications.
  ///
  /// Contains keys like: `serviceType`, `description`, `date`,
  /// `governorate`, `city`, `addressDetail`, `pricingUnit`, `price`,
  /// `status` (pending | accepted | modified | rejected), `providerName`, `notes`.
  final Map<String, dynamic>? requestPayload;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.messageType = 'text',
    this.requestPayload,
  });

  /// Whether this message was sent by the given [uid].
  bool isMine(String uid) => senderId == uid;

  /// Whether this is a service request or modification (has a payload).
  bool get isRequest =>
      messageType == 'service_request' || messageType == 'modification';

  /// Whether this is a status update (system message).
  bool get isStatusUpdate => messageType == 'status_update';

  /// The current status of the request payload (e.g., 'pending', 'accepted').
  String get requestStatus =>
      requestPayload?['status'] as String? ?? 'pending';

  // ─── Serialization ────────────────────────────────────────────────────────

  factory MessageModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return MessageModel(
      id: id,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] as bool? ?? false,
      messageType: map['messageType'] as String? ?? 'text',
      requestPayload: map['requestPayload'] != null
          ? Map<String, dynamic>.from(map['requestPayload'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': isRead,
      'messageType': messageType,
      if (requestPayload != null) 'requestPayload': requestPayload,
    };
  }
}
