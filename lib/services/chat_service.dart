import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/core/errors/app_exception.dart';
import 'package:khedma/models/chat_room_model.dart';
import 'package:khedma/models/message_model.dart';

/// Handles all Firestore operations for the real-time chat feature.
///
/// - Creates and retrieves chat rooms deterministically.
/// - Sends messages with atomic batch updates.
/// - Provides real-time streams for both chat rooms and messages.
class ChatService {
  final FirebaseFirestore _firestore;

  ChatService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Collection reference ─────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _chatRooms =>
      _firestore.collection('chatRooms');

  // ─── Deterministic Room ID ────────────────────────────────────────────────

  /// Generates a deterministic, unique chat room ID from two UIDs.
  ///
  /// Sorting guarantees that `generateRoomId(a, b) == generateRoomId(b, a)`.
  String generateRoomId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // ─── Get or Create Chat Room ──────────────────────────────────────────────

  /// Returns the existing chat room between two users, or creates a new one.
  ///
  /// Uses the deterministic room ID to prevent duplicate rooms.
  Future<ChatRoomModel> getOrCreateChatRoom({
    required String myUid,
    required String otherUid,
    required String myName,
    required String otherName,
    String myImage = '',
    String otherImage = '',
  }) async {
    try {
      final roomId = generateRoomId(myUid, otherUid);
      final roomDoc = await _chatRooms.doc(roomId).get();

      if (roomDoc.exists) {
        return ChatRoomModel.fromMap(roomDoc.data()!, id: roomId);
      }

      // Room doesn't exist — create it.
      final newRoom = ChatRoomModel(
        id: roomId,
        participants: [myUid, otherUid],
        participantNames: {myUid: myName, otherUid: otherName},
        participantImages: {myUid: myImage, otherUid: otherImage},
        createdAt: DateTime.now(),
      );

      await _chatRooms.doc(roomId).set({
        ...newRoom.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return newRoom;
    } on FirebaseException catch (e) {
      throw AppException('فشل إنشاء غرفة المحادثة', code: e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Send Message ─────────────────────────────────────────────────────────

  /// Sends a text message and atomically updates the room's last message info.
  ///
  /// Uses a Firestore batch for atomicity — either both writes succeed or
  /// neither does.
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      final batch = _firestore.batch();

      // 1. Create the message document in the subcollection.
      final messageRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc(); // auto-ID

      batch.set(messageRef, {
        'senderId': senderId,
        'text': text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // 2. Update the room's last-message metadata for the chat list.
      batch.update(_chatRooms.doc(chatRoomId), {
        'lastMessage': text.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderId,
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException('فشل إرسال الرسالة', code: e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Streams ──────────────────────────────────────────────────────────────

  /// Real-time stream of all chat rooms the user participates in,
  /// ordered by the most recent message (server-side scaled).
  Stream<List<ChatRoomModel>> getChatRoomsStream(String myUid) {
    return _chatRooms
        .where('participants', arrayContains: myUid)
        .orderBy('lastMessageTime', descending: true)
        .limit(20)
        .snapshots()
        .handleError((error) {
          if (error is FirebaseException && error.code == 'failed-precondition') {
            print('\n======================================================');
            print('🔥 FIRESTORE INDEX REQUIRED 🔥');
            print('Please copy and paste the link below into your browser to create the composite index:');
            print(error.message);
            print('======================================================\n');
          }
          throw error;
        })
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChatRoomModel.fromMap(doc.data(), id: doc.id);
          }).toList();
        });
  }

  /// Real-time stream of messages in a specific chat room,
  /// ordered chronologically (oldest first for display).
  Stream<List<MessageModel>> getMessagesStream(String chatRoomId) {
    return _chatRooms
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageModel.fromMap(doc.data(), id: doc.id);
          }).toList();
        });
  }

  // ─── Mark Messages as Read ────────────────────────────────────────────────

  /// Marks all unread messages from the other user as read.
  ///
  /// Called when the user opens a chat room.
  Future<void> markMessagesAsRead({
    required String chatRoomId,
    required String myUid,
  }) async {
    try {
      // Fetch all unread messages in this room (doesn't require a composite index)
      final unreadSnapshot = await _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .get();

      // Filter in Dart to find messages sent by the other user
      final unreadDocs = unreadSnapshot.docs
          .where((doc) => doc.data()['senderId'] != myUid)
          .toList();

      if (unreadDocs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in unreadDocs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException('فشل تحديث حالة القراءة', code: e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }
}
