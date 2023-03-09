import 'package:firebase_auth/firebase_auth.dart';

abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoggedInState extends SignUpState {
  final UserCredential firebaseUser;

  SignUpLoggedInState(this.firebaseUser);
}

class SignUpErrorState extends SignUpState {
  final String error;

  SignUpErrorState(this.error);
}

class SignUpLoadingState extends SignUpState {}
