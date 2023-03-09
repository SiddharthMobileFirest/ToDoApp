// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/auth_cubit/sign_up_cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  void registerUser(String email, String password) async {
    emit(SignUpLoadingState());
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) => emit(SignUpLoggedInState(value)));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpErrorState('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpErrorState('The account already exists for that email.'));
      }
    } catch (e) {
      emit(SignUpErrorState('The account already exists for that email.'));
    }
  }
}
