import 'dart:async';

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

  // ─── Stream Subscription ──────────────────────────────────────────────────

  StreamSubscription<List<ChatRoomModel>>? _chatRoomsSub;

  /// Starts listening to the user's chat rooms.
  ///
  /// Call this once from the UI after the cubit is created.
  void loadChatRooms() {
    emit(MessagesLoadingState());

    _chatRoomsSub = _chatService.getChatRoomsStream(myUid).listen(
      (rooms) {
        _allChatRooms = rooms;
        if (!isClosed) emit(ChatRoomsLoadedState());
      },
      onError: (error) {
        if (!isClosed) {
          emit(MessagesErrorState('فشل تحميل المحادثات'));
        }
      },
    );
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
    _chatRoomsSub?.cancel();
    return super.close();
  }
}
