abstract class MessagesStates {}

class MessagesInitial extends MessagesStates {}

/// Emitted while the chat rooms stream is being established.
class MessagesLoadingState extends MessagesStates {}

/// Emitted every time the chat rooms stream delivers new data.
class ChatRoomsLoadedState extends MessagesStates {}

/// Emitted on a Firestore error during streaming.
class MessagesErrorState extends MessagesStates {
  final String error;
  MessagesErrorState(this.error);
}

/// Emitted when the user toggles between "الكل" and "المفضلة".
class MessagesChangeViewModeState extends MessagesStates {}
