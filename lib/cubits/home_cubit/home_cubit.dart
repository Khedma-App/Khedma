import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_states.dart';

// ما تنساش تعمل import لصفحة HomeScreen الحقيقية
import '../../screens/home_screen.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 3;

  List<Widget> screens = [
    const HomeScreen(), 
    const HomeScreen(), 
    const HomeScreen(),
    const HomeScreen(), 
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }
}
