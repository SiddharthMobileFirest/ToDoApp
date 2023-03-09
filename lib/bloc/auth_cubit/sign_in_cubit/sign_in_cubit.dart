// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/auth_cubit/sign_in_cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  UserCredential? currentUser;

  SignInCubit() : super(SignInInitialState());

  void logIn(String email, String password) async {
    emit(SignInLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(SignInLoggedInState(credential));
      currentUser = credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SignInErrorState("user not found"));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        emit(SignInErrorState("Incorrect password"));
        print('Wrong password provided for that user.');
      }
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    emit(SignInLoggedOutState());
  }
}
