// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_test_app/presentation/models/login_model.dart';
import 'package:expense_test_app/presentation/repositories/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository _userRepository;

  LoginCubit(this._userRepository) : super(LoginInitial());

  Future<void> login(String phoneNumber, String name, String email) async {
    emit(LoginLoading());
    try {
      LoginModel? user = await _userRepository.getUser(phoneNumber);
      if (user == null) {
        LoginModel newUser = LoginModel(phoneNumber: phoneNumber, name: name, email: email);
        await _userRepository.insertUser(newUser);
        emit(LoginSuccess(user: newUser));
      } else {
        emit(LoginSuccess(user: user));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
