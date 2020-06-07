import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/services/baseAuth.dart';
import 'package:idomuss/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Cliente _client;

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Stream<Cliente> get client {
    return Stream.value(_client);
  }

  Future signIn(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      _client = await DatabaseService(uid: user.uid).getCliente();

      _client.email = user.email;
      _client.nome = user.displayName;
      _client.foto = user.photoUrl;
      _client.numeroCelular = user.phoneNumber;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUp(String email, String password, Cliente client) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      /*_auth.verifyPhoneNumber(
          phoneNumber: client.numeroCelular,
          timeout: const Duration(minutes: 2),
          verificationCompleted: (credential) async {
            await (await _auth.currentUser())
                .updatePhoneNumberCredential(credential);
          },
          codeSent: (verificationId, [forceResendingToken]) async {
            String smsCode;
            final AuthCredential credential = PhoneAuthProvider.getCredential(
                verificationId: verificationId, smsCode: smsCode);
            await (await _auth.currentUser())
                .updatePhoneNumberCredential(credential);
          });*/

      _client = client;
      FirebaseUser user = result.user;

      //user.sendEmailVerification();
      uploadPic(client.fotoFile);

      await DatabaseService(uid: user.uid).updateUserData(client);

      UserUpdateInfo updateInfo = new UserUpdateInfo();
      updateInfo.displayName = client.nome;
      updateInfo.photoUrl = client.foto;
      user.updateProfile(updateInfo);
  
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future uploadPic(File image) async{
      String fileName = basename(image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
  }

  Future updateEmail(String newEmail) async {
    try {
      (await _auth.currentUser()).updateEmail(newEmail);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updatePassword(String newPassword) async {
    try {
      (await _auth.currentUser()).updatePassword(newPassword);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteUser() async {
    try {
      FirebaseUser user = (await _auth.currentUser());
      DatabaseService(uid: user.uid).deleteUserData();
      user.delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //forgot password
  Future resetPassword(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  // using google
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      _client = await DatabaseService(uid: user.uid).getCliente();

      _client.email = user.email;
      _client.nome = user.displayName;
      _client.foto = user.photoUrl;
      _client.numeroCelular = user.phoneNumber;
    } catch (erro) {
      print(erro);
      return null;
    }
  }

  Future signOutGoogle() async {
    await googleSignIn.signOut();
  }
}
