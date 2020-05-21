import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomuss/models/cliente.dart';

abstract class BaseAuth {
  Future signIn(String email, String password);

  Future signUp(String email, String password, Cliente client);

  Future<FirebaseUser> getCurrentUser();

  Future sendEmailVerification();

  Future signOut();

  Future deleteUser();

  Future<bool> isEmailVerified();

  Future signInWithGoogle();

  Future signOutGoogle();
}
