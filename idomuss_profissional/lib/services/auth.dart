import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/services/baseAuth.dart';
import 'package:idomussprofissional/services/database.dart';

class AuthService implements BaseAuth {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<Profissional> signIn(String email, String password) async{
    try{
      var result = await  _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      Profissional profissional = await DatabaseService(uid: user.uid).getProfissional();

      profissional.email = user.email;
      profissional.nome = user.displayName;
      profissional.foto = user.photoUrl;
      profissional.numeroCelular = user.phoneNumber;

      return profissional;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<Profissional> signUp(String email, String password, Profissional profissional) async{
    try{
      var result = await  _auth.createUserWithEmailAndPassword(email: email, password: password);

      _auth.verifyPhoneNumber(
          phoneNumber: profissional.numeroCelular,
          timeout:  const Duration(minutes: 2),
          verificationCompleted: (credential) async{
            await (await _auth.currentUser()).updatePhoneNumberCredential(credential);
          },
          codeSent: (verificationId, [forceResendingToken]) async {
            String smsCode;
            final AuthCredential credential =
            PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
            await (await _auth.currentUser()).updatePhoneNumberCredential(credential);
          }
      );

      FirebaseUser user = result.user;

      UserUpdateInfo updateInfo = new UserUpdateInfo();

      updateInfo.displayName = profissional.nome;
      updateInfo.photoUrl = profissional.foto;

      user.updateProfile(updateInfo);

      profissional.email = user.email;

      return profissional;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateEmail(String newEmail) async{
    try{
      (await _auth.currentUser()).updateEmail(newEmail);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updatePassword(String newPassword) async{
    try{
      (await _auth.currentUser()).updatePassword(newPassword);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future deleteUser() async{
    try{
      FirebaseUser user = (await _auth.currentUser());
      DatabaseService(uid: user.uid).deleteUserData();
      user.delete();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // using google
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Profissional> signInWithGoogle()  async {

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    Profissional profissional = await DatabaseService(uid: user.uid).getProfissional();

    profissional.email = user.email;
    profissional.nome = user.displayName;
    profissional.foto = user.photoUrl;
    profissional.numeroCelular = user.phoneNumber;

    return profissional;
  }

  Future signOutGoogle() async{
    await googleSignIn.signOut();
  }
}