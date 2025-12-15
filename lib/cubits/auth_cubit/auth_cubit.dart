import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_states.dart'; 

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthLoginState());

  void switchToLogin() {
    emit(AuthLoginState());
  }

  void switchToRegister() {
    emit(AuthRegisterState());
  }
}