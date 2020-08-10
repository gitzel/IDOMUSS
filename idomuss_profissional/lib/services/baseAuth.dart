import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomussprofissional/models/profissional.dart';

abstract class BaseAuth {
  Future signIn(String email, String password);

  Future signUp(String email, String password, Profissional client);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  Future<void> deleteUser();

  Future signInWithGoogle();

  Future<void> signOutGoogle();
}
