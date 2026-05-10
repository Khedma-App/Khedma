import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khedma/core/errors/app_exception.dart';
import 'package:khedma/models/chat_room_model.dart';
import 'package:khedma/models/message_model.dart';

/// Handles all Firestore operations for the real-time chat feature.
///
/// - Creates and retrieves chat rooms deterministically.
/// - Sends text messages, service requests, modifications, and status updates.
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

  // ─── Send Text Message ────────────────────────────────────────────────────

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
        'messageType': 'text',
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

  // ─── Send Service Request ─────────────────────────────────────────────────

  /// Sends a service request message with the full booking payload.
  ///
  /// Called after the client fills the booking form and submits.
  Future<void> sendServiceRequest({
    required String chatRoomId,
    required String senderId,
    required Map<String, dynamic> requestPayload,
  }) async {
    try {
      final batch = _firestore.batch();

      final messageRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc();

      batch.set(messageRef, {
        'senderId': senderId,
        'text': '📋 طلب خدمة جديد',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'messageType': 'service_request',
        'requestPayload': {
          ...requestPayload,
          'status': 'pending',
        },
      });

      batch.update(_chatRooms.doc(chatRoomId), {
        'lastMessage': '📋 طلب خدمة جديد',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderId,
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException('فشل إرسال طلب الخدمة', code: e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Accept Service Request ───────────────────────────────────────────────

  /// Accepts a pending service request.
  ///
  /// Updates the original request's status to `'accepted'` and sends a
  /// `status_update` message notifying the client.
  Future<void> acceptServiceRequest({
    required String chatRoomId,
    required String requestMessageId,
    required String acceptedByUid,
  }) async {
    try {
      final batch = _firestore.batch();

      // 1. Update the original request's status.
      final requestRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc(requestMessageId);

      batch.update(requestRef, {
        'requestPayload.status': 'accepted',
      });

      // 2. Send a status_update message.
      final statusRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc();

      batch.set(statusRef, {
        'senderId': acceptedByUid,
        'text': 'تم قبول طلبك ✅ ... يمكنك الآن بدء المحادثة',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'messageType': 'status_update',
      });

      batch.update(_chatRooms.doc(chatRoomId), {
        'lastMessage': 'تم قبول الطلب ✅',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': acceptedByUid,
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException('فشل قبول الطلب', code: e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Request Modification ─────────────────────────────────────────────────

  /// Sends a modification request and marks the previous request as `'modified'`.
  ///
  /// The [modifiedPayload] contains the new terms proposed by either party.
  Future<void> requestModification({
    required String chatRoomId,
    required String originalMessageId,
    required String senderId,
    required Map<String, dynamic> modifiedPayload,
  }) async {
    try {
      final batch = _firestore.batch();

      // 1. Mark the original request as 'modified'.
      final originalRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc(originalMessageId);

      batch.update(originalRef, {
        'requestPayload.status': 'modified',
      });

      // 2. Send a new modification message.
      final modRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc();

      batch.set(modRef, {
        'senderId': senderId,
        'text': '📝 طلب تعديل',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'messageType': 'modification',
        'requestPayload': {
          ...modifiedPayload,
          'status': 'pending',
        },
      });

      batch.update(_chatRooms.doc(chatRoomId), {
        'lastMessage': '📝 طلب تعديل',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderId,
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException('فشل إرسال طلب التعديل', code: e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Reject Service Request ───────────────────────────────────────────────

  /// Rejects (cancels) a pending service request.
  ///
  /// Updates the request's status to `'rejected'` and sends a
  /// `status_update` message notifying the other party.
  Future<void> rejectServiceRequest({
    required String chatRoomId,
    required String requestMessageId,
    required String rejectedByUid,
  }) async {
    try {
      final batch = _firestore.batch();

      // 1. Update the original request's status.
      final requestRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc(requestMessageId);

      batch.update(requestRef, {
        'requestPayload.status': 'rejected',
      });

      // 2. Send a status_update message.
      final statusRef = _chatRooms
          .doc(chatRoomId)
          .collection('messages')
          .doc();

      batch.set(statusRef, {
        'senderId': rejectedByUid,
        'text': 'تم إلغاء الطلب ❌',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'messageType': 'status_update',
      });

      batch.update(_chatRooms.doc(chatRoomId), {
        'lastMessage': 'تم إلغاء الطلب ❌',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': rejectedByUid,
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException('فشل إلغاء الطلب', code: e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Combined: Submit Booking & Create Room ───────────────────────────────

  /// High-level method called from the booking screen.
  ///
  /// 1. Reads the current user's name from Firestore (inside the service layer).
  /// 2. Creates (or fetches) the chat room.
  /// 3. Sends the first `service_request` message.
  /// 4. Returns the [ChatRoomModel] so the UI can navigate to `ChatScreen`.
  ///
  /// All Firebase logic is encapsulated here — the UI passes only form data.
  Future<ChatRoomModel> submitBookingRequest({
    required String providerUid,
    required String providerName,
    required String providerImage,
    required Map<String, dynamic> requestPayload,
  }) async {
    try {
      // Read current user from FirebaseAuth (synchronous — already in memory).
      final currentUser = FirebaseAuth.instance.currentUser;
      final myUid = currentUser?.uid ?? '';

      if (myUid.isEmpty) {
        throw AppException('يجب تسجيل الدخول أولاً');
      }

      // Fetch current user's display name from Firestore (one-shot read
      // inside the service layer — NOT in the UI).
      final userDoc =
          await _firestore.collection('users').doc(myUid).get();
      final userData = userDoc.data() ?? {};
      String myName =
          '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
              .trim();

      // Fallback: try FirebaseAuth displayName
      if (myName.isEmpty) {
        myName = currentUser?.displayName ?? '';
      }

      // 1. Get or create the chat room.
      final room = await getOrCreateChatRoom(
        myUid: myUid,
        otherUid: providerUid,
        myName: myName.isEmpty ? 'مستخدم' : myName,
        otherName: providerName,
        otherImage: providerImage,
      );

      // 2. Send the service request as the first message.
      await sendServiceRequest(
        chatRoomId: room.id,
        senderId: myUid,
        requestPayload: {
          ...requestPayload,
          'providerName': providerName,
        },
      );

      return room;
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Streams ──────────────────────────────────────────────────────────────

  /// Real-time stream of all chat rooms the user participates in,
  /// ordered by the most recent message (server-side scaled).
  /// Builds a paginated query for chat rooms.
  Query getChatRoomsQuery(String myUid, {DocumentSnapshot? lastDoc}) {
    Query query = _chatRooms
        .where('participants', arrayContains: myUid)
        .orderBy('lastMessageTime', descending: true)
        .limit(20);
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    return query;
  }

  /// Real-time stream of all chat rooms the user participates in (Legacy/Optional limit)
  Stream<List<ChatRoomModel>> getChatRoomsStream(String myUid) {
    return _chatRooms
        .where('participants', arrayContains: myUid)
        .orderBy('lastMessageTime', descending: true)
        .limit(20)
        .snapshots()
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

  // ─── Provider Orders Stream ────────────────────────────────────────────────

  /// Real-time stream of service requests addressed to the provider.
  ///
  /// Returns enriched maps containing room metadata + latest request payload.
  /// Each map has: `chatRoomId`, `messageId`, `clientName`, `clientUid`,
  /// `requestPayload`, `timestamp`, `messageType`.
  Stream<List<Map<String, dynamic>>> watchProviderRequests(String providerUid) {
    return _chatRooms
        .where('participants', arrayContains: providerUid)
        .snapshots()
        .asyncMap((roomsSnapshot) async {
      final List<Map<String, dynamic>> allRequests = [];

      for (final roomDoc in roomsSnapshot.docs) {
        final room = ChatRoomModel.fromMap(roomDoc.data(), id: roomDoc.id);
        final clientUid = room.getOtherUid(providerUid);
        String clientName = room.getOtherName(providerUid);

        // ── Fallback: fetch real name from users collection ──
        if (clientName == 'مستخدم' && clientUid.isNotEmpty) {
          try {
            final userDoc =
                await _firestore.collection('users').doc(clientUid).get();
            if (userDoc.exists) {
              final data = userDoc.data() ?? {};
              final realName =
                  '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'
                      .trim();
              if (realName.isNotEmpty) clientName = realName;
            }
          } catch (_) {}
        }

        // Get limited service_request/modification messages in this room.
        final messagesSnapshot = await roomDoc.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(50)
            .get();

        for (final msgDoc in messagesSnapshot.docs) {
          final data = msgDoc.data();
          final msgType = data['messageType'] as String? ?? 'text';
          if (msgType != 'service_request' && msgType != 'modification') {
            continue;
          }

          final payload =
              Map<String, dynamic>.from(data['requestPayload'] ?? {});
          final status = payload['status'] as String? ?? 'pending';

          // Only include pending and accepted requests.
          if (status != 'pending' && status != 'accepted') continue;

          allRequests.add({
            'chatRoomId': roomDoc.id,
            'messageId': msgDoc.id,
            'clientName': clientName,
            'clientUid': clientUid,
            'clientImage': room.getOtherImage(providerUid),
            'requestPayload': payload,
            'timestamp': data['timestamp'],
            'messageType': msgType,
            'status': status,
          });

          // DO NOT break — collect ALL active requests from this room.
        }
      }

      return allRequests;
    });
  }

  // ─── Client Orders Stream ─────────────────────────────────────────────────

  /// Real-time stream of all service requests the client has sent.
  ///
  /// Returns enriched maps with: `chatRoomId`, `messageId`, `providerName`,
  /// `requestPayload`, `timestamp`, `status`.
  Stream<List<Map<String, dynamic>>> watchClientOrders(String clientUid) {
    return _chatRooms
        .where('participants', arrayContains: clientUid)
        .snapshots()
        .asyncMap((roomsSnapshot) async {
      final List<Map<String, dynamic>> allOrders = [];

      for (final roomDoc in roomsSnapshot.docs) {
        final room = ChatRoomModel.fromMap(roomDoc.data(), id: roomDoc.id);
        final providerUid = room.getOtherUid(clientUid);
        String providerName = room.getOtherName(clientUid);

        // ── Fallback: fetch real name from users collection ──
        if (providerName == 'مستخدم' && providerUid.isNotEmpty) {
          try {
            final userDoc =
                await _firestore.collection('users').doc(providerUid).get();
            if (userDoc.exists) {
              final data = userDoc.data() ?? {};
              final realName =
                  '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'
                      .trim();
              if (realName.isNotEmpty) providerName = realName;
            }
          } catch (_) {}
        }

        // Get limited service_request messages in this room.
        final messagesSnapshot = await roomDoc.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(50)
            .get();

        for (final msgDoc in messagesSnapshot.docs) {
          final data = msgDoc.data();
          final msgType = data['messageType'] as String? ?? 'text';
          if (msgType != 'service_request' && msgType != 'modification') {
            continue;
          }

          final payload =
              Map<String, dynamic>.from(data['requestPayload'] ?? {});

          allOrders.add({
            'chatRoomId': roomDoc.id,
            'messageId': msgDoc.id,
            'providerName': providerName,
            'providerUid': providerUid,
            'providerImage': room.getOtherImage(clientUid),
            'requestPayload': payload,
            'timestamp': data['timestamp'],
            'messageType': msgType,
            'status': payload['status'] as String? ?? 'pending',
          });

          // DO NOT break — collect ALL orders from this room.
        }
      }

      return allOrders;
    });
  }
}
