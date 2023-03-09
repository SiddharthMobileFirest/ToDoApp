import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInState {}

class SignInInitialState extends SignInState {}

class SignInLoggedInState extends SignInState {
  final UserCredential firebaseUser;

  SignInLoggedInState(this.firebaseUser);
}

class SignInLoggedOutState extends SignInState {}

class SignInErrorState extends SignInState {
  final String error;

  SignInErrorState(this.error);
}

class SignInLoadingState extends SignInState {}
