abstract class MessagesStates {}

class MessagesInitial extends MessagesStates {}

// 1. حالة التحميل (عشان تعرض Spinner)
class MessagesLoadingState extends MessagesStates {}

// 2. حالة النجاح (عشان تعرض الليستة)
class MessagesSuccessState extends MessagesStates {}

// 3. حالة الخطأ (عشان تعرض رسالة خطأ)
class MessagesErrorState extends MessagesStates {
  final String error;
  MessagesErrorState(this.error);
}

// 4. لما نغير بين الكل والمفضلة
class MessagesChangeViewModeState extends MessagesStates {}
