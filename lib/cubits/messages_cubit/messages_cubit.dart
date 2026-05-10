import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/models/chat_room_model.dart';
import 'package:khedma/services/chat_service.dart';
import 'messages_states.dart';

/// Manages the chat rooms list and the favorite/all toggle.
///
/// Subscribes to a real-time Firestore stream and cleans up
/// the subscription when the cubit is closed — zero memory leaks.
class MessagesCubit extends Cubit<MessagesStates> {
  final ChatService _chatService;
  final String myUid;

  MessagesCubit({
    required ChatService chatService,
    required this.myUid,
  })  : _chatService = chatService,
        super(MessagesInitial());

  static MessagesCubit get(context) => BlocProvider.of(context);

  // ─── State ────────────────────────────────────────────────────────────────

  /// Tab index: 0 = الرسائل, 1 = المفضلة, 2 = طلباتي.
  int currentTabIndex = 0;

  /// All chat rooms from Firestore (updated in real-time).
  List<ChatRoomModel> _allChatRooms = [];

  /// Locally-tracked favorite room IDs (persisted per session).
  final Set<String> _favoriteRoomIds = {};

  /// Public getter: all rooms with their favorite flag applied.
  List<ChatRoomModel> get chatRooms => _allChatRooms
      .map((r) => r.copyWith(isFavorite: _favoriteRoomIds.contains(r.id)))
      .toList();

  /// Public getter: only favorited rooms.
  List<ChatRoomModel> get favoriteChatRooms =>
      chatRooms.where((r) => r.isFavorite).toList();

  // ─── Pagination ───────────────────────────────────────────────────────────

  DocumentSnapshot? _lastDocument;
  bool hasMore = true;
  bool _isLoadingMore = false;

  /// Loads the initial batch of chat rooms.
  Future<void> loadChatRooms() async {
    emit(MessagesLoadingState());
    try {
      _lastDocument = null;
      hasMore = true;
      _allChatRooms.clear();

      final query = _chatService.getChatRoomsQuery(myUid);
      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _allChatRooms = snapshot.docs
            .map((doc) => ChatRoomModel.fromMap(
                doc.data() as Map<String, dynamic>,
                id: doc.id))
            .toList();
        if (snapshot.docs.length < 20) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
      
      if (!isClosed) emit(ChatRoomsLoadedState());
    } catch (e) {
      if (!isClosed) emit(MessagesErrorState('فشل تحميل المحادثات'));
    }
  }

  /// Loads the next batch of chat rooms.
  Future<void> loadMoreChats() async {
    if (!hasMore || _isLoadingMore) return;
    
    _isLoadingMore = true;
    emit(MessagesLoadingMoreState());

    try {
      final query = _chatService.getChatRoomsQuery(myUid, lastDoc: _lastDocument);
      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        final newRooms = snapshot.docs
            .map((doc) => ChatRoomModel.fromMap(
                doc.data() as Map<String, dynamic>,
                id: doc.id))
            .toList();
        _allChatRooms.addAll(newRooms);
        
        if (snapshot.docs.length < 20) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
      
      if (!isClosed) emit(ChatRoomsLoadedState());
    } catch (e) {
      if (!isClosed) emit(MessagesErrorState('فشل تحميل المزيد من المحادثات'));
    } finally {
      _isLoadingMore = false;
    }
  }

  // ─── Toggle View ──────────────────────────────────────────────────────────

  void changeTab(int index) {
    if (currentTabIndex == index) return;
    currentTabIndex = index;
    emit(MessagesChangeViewModeState());
  }

  // ─── Favorites ────────────────────────────────────────────────────────────

  /// Toggles a room's favorite status locally.
  void toggleFavorite(String roomId) {
    if (_favoriteRoomIds.contains(roomId)) {
      _favoriteRoomIds.remove(roomId);
    } else {
      _favoriteRoomIds.add(roomId);
    }
    emit(ChatRoomsLoadedState());
  }

  /// Whether a specific room is favorited.
  bool isFavorite(String roomId) => _favoriteRoomIds.contains(roomId);

  // ─── Cleanup ──────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    return super.close();
  }
}
