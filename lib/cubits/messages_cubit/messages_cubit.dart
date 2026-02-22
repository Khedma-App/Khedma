import 'package:flutter_bloc/flutter_bloc.dart';
import 'messages_states.dart'; 

class MessagesCubit extends Cubit<MessagesStates> {
  MessagesCubit() : super(MessagesInitial());

  static MessagesCubit get(context) => BlocProvider.of(context);

  // المتغير اللي بيحدد الشاشة (false = الكل، true = المفضلة)
  bool isFavoriteScreen = false;

  // دالة تغيير الشاشة
  void changeScreen(bool isFav) {
    if (isFavoriteScreen == isFav) return; // لو داس على نفس الزرار ميعملش حاجة

    isFavoriteScreen = isFav;
    emit(MessagesChangeViewModeState()); // تحديث الـ UI
  }
}
