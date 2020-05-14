import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomuss/models/cliente.dart';

abstract class BaseAuth {

  Future<Cliente> signIn(String email, String password);

  Future<Cliente> signUp(String email, String password, Cliente client);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<void> deleteUser();

  Future<bool> isEmailVerified();

  Future<Cliente> signInWithGoogle();

  Future<void> signOutGoogle();
}