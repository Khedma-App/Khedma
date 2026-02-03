import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteListCubit extends Cubit<List<dynamic>> {
  FavoriteListCubit() : super([]);

  void addFavorite(dynamic item) {
    final updatedList = List<dynamic>.from(state)..add(item);
    emit(updatedList);
  }

  void removeFavorite(dynamic item) {
    final updatedList = List<dynamic>.from(state)..remove(item);
    emit(updatedList);
  }
}