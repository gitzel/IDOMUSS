import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomussprofissional/models/profissional.dart';

abstract class BaseAuth {

  Future<Profissional> signIn(String email, String password);

  Future<Profissional> signUp(String email, String password, Profissional client);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<void> deleteUser();

  Future<bool> isEmailVerified();

  Future<Profissional> signInWithGoogle();

  Future<void> signOutGoogle();
}